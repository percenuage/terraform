resource "google_storage_bucket" "buckets" {
  for_each = toset(var.bucket_names)

  name = "${local.project}-${each.value}"
  location = var.location
  uniform_bucket_level_access = true

  dynamic "lifecycle_rule" {
    for_each = try(var.bucket_lifecycle[each.value], false) == false ? [] : [1]

    content {
      condition {
        age = var.bucket_lifecycle[each.value]
      }
      action {
        type = "Delete"
      }
    }
  }

  versioning {
    enabled = false
  }

  labels = {
    env = var.env
    project = var.namespace
    terraform = true
  }
}

resource "google_storage_bucket_iam_binding" "viewers" {
  for_each = var.bucket_viewers

  bucket = google_storage_bucket.buckets[each.key].name
  role = "roles/storage.objectViewer"
  members = split(",", each.value)
}

resource "google_storage_bucket_iam_binding" "creators" {
  for_each = var.bucket_creators

  bucket = google_storage_bucket.buckets[each.key].name
  role = "roles/storage.objectCreators"
  members = split(",", each.value)
}
