terraform {
  backend "gcs" {
    bucket = "my-state-bucket-aqeel"
    prefix = "terraform/state" 
  }
}
