## Enable Services
resource "google_project_service" "bigquery" {
  project = var.project_id
  service = "bigquery.googleapis.com"
}

## Create BigQuery Dataset
resource "google_bigquery_dataset" "presence_portal" {
  depends_on = [google_project_service.bigquery]
  dataset_id = var.dataset_id
  location   = var.location
}

# TODO move into separate module - like data-transfer - just import module here (data-tranfer is imported in root because we might not always need a data_tranfer but we always need a dataset and tables)
## Create BigQuery Tables
module "tables" {
  depends_on = [
    google_bigquery_dataset.presence_portal
  ]
  source = "./tables"

  dataset_id = google_bigquery_dataset.presence_portal.dataset_id
}
