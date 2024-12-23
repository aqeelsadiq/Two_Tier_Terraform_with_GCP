


module "vpc" {
  source         = "../modules/vpc"
  project_id     = var.project_id
  pub_subnetwork = var.pub_subnetwork
  pri_subnetwork = var.pri_subnetwork

}



module "serviceaccount" {
  source          = "../modules/serviceaccount"
  project_id      = var.project_id
  service_account = var.service_account
  depends_on      = [module.vpc]

}


module "cloudsql" {
  source           = "../modules/cloudsql"
  private_network  = module.vpc.vpc_name
  region           = var.region
  cloud_sql_config = var.cloud_sql_config
  depends_on       = [module.vpc]
}


module "instancetemplate" {
  source                = "../modules/instancetemplate"
  private_network       = module.vpc.vpc_name
  region                = var.region
  subnetwork            = module.vpc.public_subnet
  service_account_email = module.serviceaccount.email
  sql_instance_name     = module.cloudsql.cloudsql_instance_name
  instance_templates    = var.instance_templates
  depends_on            = [module.firewall]
}


module "mig" {
  source                 = "../modules/mig"
  instance_template_name = module.instancetemplate.instance_template_name
  zone                   = var.zone
  depends_on             = [module.instancetemplate]

}

module "firewall" {
  source          = "../modules/firewall"
  private_network = module.vpc.vpc_name
  project_id      = var.project_id
  firewall        = var.firewall
  depends_on      = [module.cloudsql]
}