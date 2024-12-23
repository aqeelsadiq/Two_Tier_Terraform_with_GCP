
output "cloudsql_instance_name" {
  value = [for key, instance in google_sql_database_instance.cloud_sql : instance.name]
}
