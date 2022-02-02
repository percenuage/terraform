output "db" {
  value = {
    connection_name = google_sql_database_instance.master.connection_name
    public_ip_address = google_sql_database_instance.master.public_ip_address
    databases = var.databases
    users = local.users
  }
}
