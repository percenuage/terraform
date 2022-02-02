resource "google_compute_address" "static" {
  name = "${local.project}-ip-nat"
}

resource "google_compute_router" "router" {
  name = "${local.project}-router"
  network = var.network_name
  region = var.region
}

resource "google_compute_router_nat" "nat" {
  name = "${local.project}-nat"
  router = google_compute_router.router.name
  region = google_compute_router.router.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips = google_compute_address.static.*.self_link

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name = var.subnetwork_name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  log_config {
    enable = true
    filter = "ALL"
  }
}
