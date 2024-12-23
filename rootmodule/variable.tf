variable "project_id" {}
variable "region" {}
variable "zone" {}

variable "pub_subnetwork" {
  type = list(map(string))
}
variable "pri_subnetwork" {
  type = list(map(string))
}

variable "instance_templates" {
  type = list(map(string))
}

variable "cloud_sql_config" {
  type = list(map(string))
}

variable "service_account" {
  type = list(map(string))
}

variable "firewall" {
  type = list(map(string))
}
