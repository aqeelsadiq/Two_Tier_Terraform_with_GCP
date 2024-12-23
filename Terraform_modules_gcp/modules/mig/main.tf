resource "google_compute_health_check" "health_check" {
  name               = "${terraform.workspace}-health-check-aqeel"
  check_interval_sec = 15
  timeout_sec        = 15
  healthy_threshold   = 3
  unhealthy_threshold = 2

  http_health_check {
    port        = 80
    request_path = "/wp-admin/install.php"
  }
}

resource "google_compute_instance_group_manager" "ins_group" {
  name               = "${terraform.workspace}-mig-aqeel"
  base_instance_name = "${terraform.workspace}-wordpress-instance"
  zone               = var.zone
  target_size        = 2
  
  auto_healing_policies {
    health_check      = google_compute_health_check.health_check.self_link
    initial_delay_sec = 300
  }

  named_port {
    name = "http"
    port = 80
  }

  version {
    instance_template = var.instance_template_name[0]
    name              = "v1" 

  }

}

# Autoscaler
resource "google_compute_autoscaler" "auto_scaler" {
  name   = "${terraform.workspace}-autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.ins_group.self_link

  autoscaling_policy {
    min_replicas    = 2
    max_replicas    = 5
    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_backend_service" "backend_service" {
  name                  = "${terraform.workspace}-backend-service"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTP"
  timeout_sec           = 30

  backend {
    group            = google_compute_instance_group_manager.ins_group.instance_group
    balancing_mode   = "UTILIZATION"
    max_utilization  = 0.8
  }

  health_checks = [google_compute_health_check.health_check.self_link]

  connection_draining_timeout_sec = 300
  depends_on = [ google_compute_health_check.health_check, google_compute_instance_group_manager.ins_group ]
}

resource "google_compute_url_map" "url_map" {
  name            = "${terraform.workspace}-http-url-map"
  default_service = google_compute_backend_service.backend_service.self_link
  depends_on = [ google_compute_backend_service.backend_service ]
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name   = "${terraform.workspace}-http-target-proxy"
  url_map = google_compute_url_map.url_map.self_link
  depends_on = [ google_compute_url_map.url_map ]
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name                  = "${terraform.workspace}-aqeel-lb"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_proxy.self_link
  depends_on = [ google_compute_target_http_proxy.http_proxy ]
}
