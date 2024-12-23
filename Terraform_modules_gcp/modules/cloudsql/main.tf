resource "google_sql_database_instance" "cloud_sql" {
  for_each = {for cloudsql in var.cloud_sql_config : cloudsql.sql_instance_name => cloudsql}
  name             = "${terraform.workspace}-${each.value.sql_instance_name}"
  region           = var.region
  database_version = each.value.database_version
  

  settings {
    ip_configuration {
      ipv4_enabled   = false
      private_network = var.private_network
    }
    tier             = each.value.tier
    disk_type    = "PD_SSD"
    disk_size = 10
    availability_type = "REGIONAL"

    backup_configuration {
      enabled = true
      binary_log_enabled = true
    }
  }

  root_password = each.value.root_password
  deletion_protection = false

  depends_on = [var.cloud_sql_config]

}

resource "google_sql_database" "db_name" {
  for_each = {for cloudsql in var.cloud_sql_config : cloudsql.sql_instance_name => cloudsql}
  name     = each.value.database_name
  instance = google_sql_database_instance.cloud_sql[each.key].name
  depends_on = [ google_sql_database_instance.cloud_sql ]
}

resource "google_sql_user" "users" {
  for_each = {for cloudsql in var.cloud_sql_config : cloudsql.sql_instance_name => cloudsql}
  name     = "root"
  instance = google_sql_database_instance.cloud_sql[each.key].name
  password = each.value.root_password
  host = "%"
}