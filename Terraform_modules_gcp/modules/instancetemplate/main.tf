
resource "google_compute_instance_template" "instance_template" {
  for_each = { for template in var.instance_templates : template.name => template }
  name          = "${terraform.workspace}-${each.value.name}"
  region        = var.region
  machine_type  = each.value.machine_type

  network_interface {
    network = var.private_network
    subnetwork = var.subnetwork["pub-subnet-1"]

    access_config {     
    }
  }


  disk {
    auto_delete = true
    boot        = true
    device_name = "boot-disk"
    disk_type = each.value.disk_type
    disk_size_gb = each.value.disk_size_gb
    source_image =  each.value.image_family
  }

  service_account {
    email  = var.service_account_email[0]
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  metadata = {
    startup-script = file("${path.module}/startup-script.sh")
    sql-instance-name = var.sql_instance_name[0]
  }

}


