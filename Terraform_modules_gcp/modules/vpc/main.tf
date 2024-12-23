resource "google_compute_network" "myvpc" {
  name                    = "${terraform.workspace}-myaqeel-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "public_subnet" {
  for_each = { for subnet in var.pub_subnetwork : subnet.name => subnet }
  name          = "${terraform.workspace}-${each.value.name}"
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  network       = google_compute_network.myvpc.name
  private_ip_google_access = false
}

resource "google_compute_subnetwork" "private_subnet" {
  for_each = { for subnet in var.pri_subnetwork : subnet.name => subnet }
  name          = "${terraform.workspace}-${each.value.name}"
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region  
  network       = google_compute_network.myvpc.name
  private_ip_google_access = true
}

resource "google_compute_global_address" "private_ip_allocation" {
  name          = "${terraform.workspace}my-cloud-sql-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.myvpc.self_link
}

resource "google_service_networking_connection" "vpc_peering" {
  network                 = google_compute_network.myvpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_allocation.name]
}

