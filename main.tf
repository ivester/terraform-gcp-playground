provider "google" {
  project = var.project_id
  region  = var.region
}

module "project_config" {
  source = "./modules/project-config"

  project_id      = var.project_id
  project_name    = var.project_name
  billing_account = var.billing_account
}

module "statistics" {
  source = "./modules/bigquery/projects/statistics"
}

module "bigquery_statistics" {
  source = "./modules/bigquery"

  project_id = var.project_id
  location   = var.region
  config     = module.statistics.config
}

## Create Bigquery Data Transfer - Statistics
module "data_transfer_statistics" {
  depends_on = [module.bigquery_statistics]
  source     = "./modules/bigquery/data-transfer"

  project_id = var.project_id
  location   = var.region
  config     = module.statistics.config
}
