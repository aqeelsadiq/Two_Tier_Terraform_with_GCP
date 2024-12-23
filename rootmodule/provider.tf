provider "google" {
  credentials = file("/home/ubuntu/Downloads/file-name")
  project     = var.project_id
  region      = var.region
}