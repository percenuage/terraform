output "cluster" {
  value = {
    id = google_container_cluster.primary.id
    static_ip = google_compute_address.static.address
    master_version = google_container_cluster.primary.master_version
  }
}
