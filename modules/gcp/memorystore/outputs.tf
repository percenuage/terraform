output "redis" {
  value = {
    id = google_redis_instance.cache.id
    host = google_redis_instance.cache.host
    port = google_redis_instance.cache.port
  }
}
