variable "region" {}
variable "private_network" {}
variable "subnetwork" {
    type = map(string)
}
variable "service_account_email" {}
variable "sql_instance_name" {}
variable "instance_templates" {}