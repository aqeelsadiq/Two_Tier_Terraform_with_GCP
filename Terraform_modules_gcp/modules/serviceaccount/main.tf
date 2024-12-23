resource "google_service_account" "wordpress_sa" {
  for_each = {for service in var.service_account : service.account_id => service}
  account_id   = "${terraform.workspace}-${each.value.account_id}"
  display_name = each.value.display_name
  project      = var.project_id
}

resource "google_project_iam_member" "wordpress_binding" {
  for_each = {for service in var.service_account : service.account_id => service}
  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.wordpress_sa[each.key].email}"
  depends_on = [google_service_account.wordpress_sa]
}
