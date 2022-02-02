output "default" {
  value = {
    hosts = local.hosts
    ip = google_compute_global_address.default.address
  }
}
