output "email" {
  value = [for sa in google_service_account.wordpress_sa : sa.email]
}

output "iam_member_email" {
  value = [for iam_member in google_project_iam_member.wordpress_binding : iam_member.member]
}
