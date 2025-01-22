resource "google_bigquery_data_transfer_config" "sync_top_10_terms" {
  display_name   = "Fetch new/updated 'top-10-terms' entries Daily"
  location       = var.location
  data_source_id = "scheduled_query"
  schedule       = var.data_transfer_schedule
  schedule_options {
    start_time = var.data_transfer_start
  }
  params = {
    query = file("./modules/bigquery/data-transfer/sync-top-10-terms.sql")
  }
}
