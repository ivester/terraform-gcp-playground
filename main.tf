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

module "statistics_prd" {
  source = "./modules/bigquery/projects/statistics-prd"
}

module "bigquery_statistics_prd" {
  source = "./modules/bigquery"

  project_id = var.project_id
  location   = var.region
  config     = module.statistics_prd.config
}

## Create Bigquery Data Transfer - Statistics
module "data_transfer_statistics_prd" {
  depends_on = [module.bigquery_statistics_prd]
  source     = "./modules/bigquery/data-transfer"

  project_id = var.project_id
  location   = var.region
  config     = module.statistics_prd.config
}
