resource "google_compute_address" "static" {
  name = "${local.project}-ip"
}

resource "google_container_cluster" "primary" {
  provider = google-beta
  name = "${local.project}-cluster"
  location = var.location
  network = var.network_name
  subnetwork = var.subnetwork_name

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  enable_shielded_nodes = true
  enable_intranode_visibility = true
  initial_node_count = 1

  logging_service = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  resource_labels = {
    env: var.env
    project: var.namespace
    managed: "terraform"
  }

  dynamic "private_cluster_config" {
    for_each = var.private ? [1] : []
    content {
      enable_private_nodes = true
      enable_private_endpoint = false
      master_ipv4_cidr_block = var.master_ipv4_cidr_block
    }
  }

  dynamic "ip_allocation_policy" {
    for_each = var.private ? [1] : []
    content {
      cluster_ipv4_cidr_block = "/16"
      services_ipv4_cidr_block  = "/16"
    }
  }

  cluster_autoscaling {
    enabled = false
    autoscaling_profile = var.autoscaling_profile
  }

  addons_config {
    dns_cache_config {
      enabled = var.dns_cache_addon
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  maintenance_policy {
    recurring_window {
      start_time = "2021-01-01T22:00:00Z"
      end_time = "2021-01-02T04:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
    }
  }

  provisioner "local-exec" {
    command = "gcloud --project ${local.project} container clusters get-credentials ${local.project}-cluster --zone ${var.location}"
  }
}

resource "google_container_node_pool" "nodes" {
  name = "${local.project}-pool"
  location = var.location
  cluster = google_container_cluster.primary.name
  node_count = var.min_node_count

  dynamic "autoscaling" {
    for_each = var.autoscale_node ? [1] : []
    content {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }
  }

  node_config {
    preemptible = var.preemptible
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type = var.disk_type
    image_type = var.image_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring",
    ]
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }

  lifecycle {
    ignore_changes = [node_count]
  }
}
