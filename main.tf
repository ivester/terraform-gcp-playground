provider "google" {
  project = var.project_id
  region  = var.region
}

module "project_config" {
  source = "./modules/project-config"

  project_id      = var.project_id
  billing_account = var.billing_account
}

module "statistics" {
  source = "./modules/bigquery/projects/statistics"
}

# TODO change bigquery name to bigquery-statistics
module "bigquery" {
  source = "./modules/bigquery"

  project_id = module.project_config.project_id
  location   = var.region
  dataset_id = module.statistics.config.dataset_id
}

## Create Bigquery Data Transfer - Statistics
# TODO change bigquery name to data_transfer-statistics
module "data_transfer" {
  depends_on = [module.bigquery]
  source     = "./modules/bigquery/data-transfer"

  project_id             = var.project_id
  project_id_source      = "terraform-test-ives" # TODO can we move that one also into module.statistics.config?
  location               = var.region
  config                 = module.statistics.config
  data_transfer_start    = "2025-01-24T14:05:00Z" # TODO can we move that one also into module.statistics.config?
  data_transfer_schedule = "every 24 hours" # TODO can we move that one also into module.statistics.config?
}
