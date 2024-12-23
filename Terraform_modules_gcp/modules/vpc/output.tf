output "vpc_name" {
    value = google_compute_network.myvpc.id 
}

output "public_subnet" {
    value = { for k, v in google_compute_subnetwork.public_subnet : k => v.self_link }
}

output "private_subnet" {
    value = { for k, v in google_compute_subnetwork.private_subnet : k => v.self_link }
  
}
output "vpc_peering" {
    value = google_service_networking_connection.vpc_peering.id
}
