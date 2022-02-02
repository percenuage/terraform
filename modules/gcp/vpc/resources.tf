resource "google_compute_network" "default" {
  name = var.namespace
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name = var.env
  region = var.region
  ip_cidr_range = var.subnetwork_cidr
  network = google_compute_network.default.id
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_30_SEC"
    flow_sampling = 0.5
    metadata = "INCLUDE_ALL_METADATA"
  }
}
