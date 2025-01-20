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

  location   = var.region
}

module "bigquery_tables" {
  depends_on = [
    module.service_bigquery,
    module.service_data_transfer,
    module.bigquery_dataset_presence_portal
  ]
  source = "./modules/bigquery_tables"

  dataset_id = module.bigquery_dataset_presence_portal.dataset_id
}

resource "google_bigquery_data_transfer_config" "sync_impressions" {
  display_name   = "Fetch new/updated 'impressions' entries Daily"
  location       = var.region
  data_source_id = "scheduled_query"
  schedule       = var.data_transfer_schedule
  schedule_options {
    start_time = var.data_transfer_start
  }
  params = {
    query = file("./sync-impressions.sql")
  }
}

resource "google_bigquery_data_transfer_config" "sync_interactions" {
  display_name   = "Fetch new/updated 'interactions' entries Daily"
  location       = var.region
  data_source_id = "scheduled_query"
  schedule       = var.data_transfer_schedule
  schedule_options {
    start_time = var.data_transfer_start
  }
  params = {
    query = file("./sync-interactions.sql")
  }
}

resource "google_bigquery_data_transfer_config" "sync_top_10_terms" {
  display_name   = "Fetch new/updated 'top-10-terms' entries Daily"
  location       = var.region
  data_source_id = "scheduled_query"
  schedule       = var.data_transfer_schedule
  schedule_options {
    start_time = var.data_transfer_start
  }
  params = {
    query = file("./sync-top-10-terms.sql")
  }
}
