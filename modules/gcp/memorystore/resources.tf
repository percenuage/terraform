resource "google_redis_instance" "cache" {
  name = "${var.namespace}-redis"
  tier = var.tier
  region = var.region
  location_id = var.zone
  memory_size_gb = var.memory_size_gb
  redis_version = var.redis_version
  authorized_network = var.network
  auth_enabled = false
}
