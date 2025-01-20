resource "google_bigquery_dataset" "presence_portal" {
  dataset_id = "presence_portal"
  location   = var.location
}

module "tables" {
  depends_on = [
    google_bigquery_dataset.presence_portal
  ]
  source = "./tables"

  dataset_id = google_bigquery_dataset.presence_portal.dataset_id
}

module "data_transfer" {
  depends_on = [
    google_bigquery_dataset.presence_portal,
    module.tables
  ]
  source = "./data_transfer"

  location               = var.location
  data_transfer_start    = var.data_transfer_start
  data_transfer_schedule = var.data_transfer_schedule
}

