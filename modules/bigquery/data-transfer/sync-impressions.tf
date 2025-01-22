resource "google_bigquery_data_transfer_config" "sync_impressions" {
  display_name   = "Fetch new/updated 'impressions' entries Daily"
  location       = var.location
  data_source_id = "scheduled_query"
  schedule       = var.data_transfer_schedule
  schedule_options {
    start_time = var.data_transfer_start
  }
  params = {
    query = file("./modules/bigquery/data-transfer/sync-impressions.sql")
  }
}
