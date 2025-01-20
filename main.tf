provider "google" {
  project = var.project_id
  region  = var.region
}

module "project_config" {
  source = "./modules/project_config"

  project_id      = var.project_id
  billing_account = var.billing_account
}

resource "google_project_service" "bigquery" {
  project = var.project_id
  service = "bigquery.googleapis.com"
}

resource "google_project_service" "data_transfer" {
  project = var.project_id
  service = "bigquerydatatransfer.googleapis.com"
}

module "bigquery" {
  depends_on = [google_project_service.bigquery, google_project_service.data_transfer]
  source     = "./modules/bigquery"

  project_id             = module.project_config.project_id
  location               = var.region
  data_transfer_start    = var.data_transfer_start
  data_transfer_schedule = var.data_transfer_schedule
}
