module "gcs" {
  source = "../gcs"

  env = var.env
  namespace = var.namespace
  location = var.location

  bucket_names = local.bucket_names
  bucket_viewers = coalesce(local.bucket_viewers, {})
  bucket_creators = coalesce(local.bucket_creators, {})
  bucket_lifecycle = coalesce(local.bucket_lifecycle, {})
}
