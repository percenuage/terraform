output "buckets" {
  value = formatlist("${local.project}-%s", var.bucket_names)
}
