output "firewall" {
    value = google_compute_firewall.http_firewall.id 
}