output "vpc" {
  value = module.vpc.network
}

output "gke" {
  value = module.gke.cluster
}

output "nat" {
  value = module.nat.google_compute_router_nat
}

output "iam" {
  value = module.iam.google_service_accounts
}

output "super_client" {
  value = {
    clients = module.super_client.clients
    buckets = module.super_client.buckets
    service_accounts = module.super_client.service_accounts
  }
}

output "gcs" {
  value = module.gcs.buckets
}

output "sql" {
  value = module.sql.db
}

output "run" {
  value = [
    module.run_percenuage_app.id,
    module.run_percenuage_api.id,
  ]
}

output "lb" {
  value = module.lb.default
}
