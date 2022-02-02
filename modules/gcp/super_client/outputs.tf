output "clients" {
  value = var.clients
}

output "buckets" {
  value = local.bucket_names
}

output "service_accounts" {
  value = formatlist("${var.namespace}-%s", var.clients)
}
