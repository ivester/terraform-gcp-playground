resource "google_project_service" "data_transfer" {
  project = var.project_id
  service = "bigquerydatatransfer.googleapis.com"
}

resource "google_bigquery_data_transfer_config" "data_transfer" {
  depends_on     = [google_project_service.data_transfer]
  for_each       = { for config in var.config.data_transfer : config.name => config }
  display_name   = each.value.name
  location       = var.location
  data_source_id = "scheduled_query"
  schedule       = var.data_transfer_schedule
  schedule_options {
    start_time = var.data_transfer_start
  }
  params = {
    # TODO assemble table name also from config in template: ${project_id}.${dataset_id}.${table_name}
    query = templatefile(
      "${each.value.template}",
      {
        project_id        = var.project_id,
        project_id_source = var.project_id_source,
        dataset_id        = var.config.dataset_id,
    })
  }
}
