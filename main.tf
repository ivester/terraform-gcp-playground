provider "google" {
  project = var.project_id
  region  = var.region
}

module "project_config" {
  source = "./modules/project_config"

  project_id      = var.project_id
  billing_account = var.billing_account
}

module "service_bigquery" {
  source = "./modules/service_bigquery"

  project_id = module.project_config.project_id
}

module "service_data_transfer" {
  source = "./modules/service_data_transfer"

  project_id = module.project_config.project_id
}

module "bigquery_dataset_presence_portal" {
  depends_on = [
    module.service_bigquery,
    module.service_data_transfer
  ]
  source = "./modules/bigquery_dataset_presence_portal"

  location = var.region
}

module "bigquery_tables" {
  depends_on = [
    module.bigquery_dataset_presence_portal
  ]
  source = "./modules/bigquery_tables"

  dataset_id = module.bigquery_dataset_presence_portal.dataset_id
}

module "bigquery_data_transfer" {
  depends_on = [
    module.bigquery_tables
  ]
  source = "./modules/bigquery_data_transfer"

  location               = var.region
  data_transfer_start    = var.data_transfer_start
  data_transfer_schedule = var.data_transfer_schedule
}
