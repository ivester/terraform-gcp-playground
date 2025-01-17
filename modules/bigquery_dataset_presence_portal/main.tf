resource "google_bigquery_dataset" "presence_portal" {
  dataset_id = "presence_portal"
  location   = var.location
}
