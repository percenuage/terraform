output "google_compute_network_id" {
  value = google_compute_network.default.id
}

output "google_compute_network_name" {
  value = google_compute_network.default.name
}

output "google_compute_subnetwork_name" {
  value = google_compute_subnetwork.default.name
}

output "network" {
  value = {
    name = google_compute_network.default.name
    subnetworks = google_compute_subnetwork.default.name
    region = google_compute_subnetwork.default.region
    cidr = google_compute_subnetwork.default.ip_cidr_range
  }
}
