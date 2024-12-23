project_id = ""
region     = "us-central1"
zone       = "us-central1-a"

pub_subnetwork = [
  {
    name          = "pub-subnet-1"
    ip_cidr_range = "10.0.1.0/24"
    region        = "us-central1"
  },
  {
    name          = "pub-subnet-2"
    ip_cidr_range = "10.0.2.0/24"
    region        = "us-central1"
  }
]

pri_subnetwork = [
  {
    name          = "pri-subnet-1"
    ip_cidr_range = "10.0.3.0/24"
    region        = "us-central1"
  },
  {
    name          = "pri-subnet-2"
    ip_cidr_range = "10.0.4.0/24"
    region        = "us-central1"
  }
]

instance_templates = [
  {
    name         = "web-instance-template"
    machine_type = "n1-standard-1"
    image_family = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
    disk_size_gb = 20
    disk_type    = "pd-balanced"
  }
]

# cloud sql 
cloud_sql_config = [
  {
    root_password     = ""
    database_name     = ""
    sql_instance_name = "cloudsql-aqeel"
    database_version  = "MYSQL_8_0"
    tier              = "db-f1-micro"
 }
]

# service account 
service_account = [
  {
    account_id   = "wordpress-svc-account"
    role         = "roles/cloudsql.client"
    display_name = "wordpress service account"
  }

]

#firewall
firewall = [
  {
    source_ranges     = "0.0.0.0/0"
    firewall_name     = "http-firewall"
    sql_firewall_name = "sql-firewall"
    sql_source_ranges = "10.0.1.0/24|10.0.2.0/24"
    zone             = "us-central1-a"
  }
]

