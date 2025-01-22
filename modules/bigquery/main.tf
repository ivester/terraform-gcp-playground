## Enable Services
resource "google_project_service" "bigquery" {
  project = var.project_id
  service = "bigquery.googleapis.com"
}

resource "google_project_service" "data_transfer" {
  project = var.project_id
  service = "bigquerydatatransfer.googleapis.com"
}

## Create BigQuery Dataset
resource "google_bigquery_dataset" "presence_portal" {
  depends_on = [google_project_service.bigquery]
  dataset_id = "presence_portal"
  location   = var.location
}

## Create BigQuery Tables
module "tables" {
  depends_on = [
    google_bigquery_dataset.presence_portal
  ]
  source = "./tables"

  dataset_id = google_bigquery_dataset.presence_portal.dataset_id
}

## Create Data Transfer
module "data_transfer" {
  depends_on = [
    google_bigquery_dataset.presence_portal,
    google_project_service.data_transfer,
    module.tables
  ]
  source = "./data-transfer"

  location               = var.location
  data_transfer_start    = "2025-01-22T16:04:00Z"
  data_transfer_schedule = "every 24 hours"
}
