resource "google_compute_firewall" "http_firewall" {
  name    = "${terraform.workspace}-${var.firewall[0]["firewall_name"]}"
  project = var.project_id
  network = var.private_network

  allow {
    protocol  = "tcp"
    ports     = [80,443, 22]
  }
  direction = "INGRESS"

  source_ranges = [var.firewall[0]["source_ranges"]]

}

resource "google_compute_firewall" "sql_firewall" {
  name    = "${terraform.workspace}-${var.firewall[0]["sql_firewall_name"]}"
  project = var.project_id
  network = var.private_network

  allow {
    protocol  = "tcp"
    ports     = [3306]
  }
  direction = "INGRESS"

  source_ranges = split("|", var.firewall[0]["sql_source_ranges"])

}