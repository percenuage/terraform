resource "google_sql_database_instance" "master" {
  name = "${var.namespace}-${var.env}-sql"
  region = var.region
  database_version = var.database_version
  deletion_protection = var.deletion_protection

  settings {
    tier = var.instance_tier
    disk_size = var.disk_size
    disk_autoresize = true
    availability_type = "ZONAL"
    user_labels = {
      env = var.env
      terraform = true
    }

    backup_configuration {
      enabled = var.enable_backup
      location = var.region
      start_time = "00:00"
    }

    maintenance_window {
      day = 1
      hour = 2
      update_track = "stable"
    }
  }
}

resource "google_sql_database" "database" {
  for_each = toset(var.databases)

  name = each.key
  instance = google_sql_database_instance.master.name
}

resource "google_sql_user" "user" {
  for_each = toset(local.users)

  name = each.key
  password = random_password.user[each.key].result
  instance = google_sql_database_instance.master.name
}

resource "google_secret_manager_secret" "user" {
  for_each = toset(local.users)

  secret_id = "${google_sql_database_instance.master.name}-${each.key}-secret"

  labels = {
    env = var.env
    service = "cloud-sql"
    instance = google_sql_database_instance.master.name
    terraform = true
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "user" {
  for_each = toset(local.users)

  secret = google_secret_manager_secret.user[each.key].id
  secret_data = random_password.user[each.key].result
}

resource "random_password" "user" {
  for_each = toset(local.users)

  length = 16
  special = true
}

