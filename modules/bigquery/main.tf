## Enable Services
resource "google_project_service" "bigquery" {
  project = var.project_id
  service = "bigquery.googleapis.com"
}

## Create BigQuery Dataset
resource "google_bigquery_dataset" "presence_portal" {
  depends_on = [google_project_service.bigquery]
  dataset_id = var.config.dataset_id
  location   = var.location
}

## Create BigQuery Tables
module "tables" {
  depends_on = [google_bigquery_dataset.presence_portal]
  source     = "./tables"

  config = var.config
}
