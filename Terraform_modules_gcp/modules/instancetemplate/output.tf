output "instance_template_name" {
  value = [for template in google_compute_instance_template.instance_template : template.self_link]
}
