provider "google" {
  project = var.project_id
  region  = var.region
}

module "project_config" {
  source = "./modules/project-config"

  project_id      = var.project_id
  billing_account = var.billing_account
}

module "bigquery" {
  source = "./modules/bigquery"

  project_id             = module.project_config.project_id
  location               = var.region
}
