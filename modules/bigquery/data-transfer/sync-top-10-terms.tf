resource "google_bigquery_data_transfer_config" "sync_top_10_terms" {
  display_name   = "Fetch new/updated 'top-10-terms' entries Daily"
  location       = var.location
  data_source_id = "scheduled_query"
  schedule       = var.data_transfer_schedule
  schedule_options {
    start_time = var.data_transfer_start
  }
  params = {
    query = templatefile("${path.module}/sync-top-10-terms.tpl", { project_id = var.project_id, project_id_source = var.project_id_source, dataset_id = var.dataset_id })
  }
}
