resource "google_bigquery_table" "bigquery_table" {
  for_each   = { for config in var.config.tables : config.name => config }
  dataset_id = var.config.dataset_id
  table_id   = each.value.name
  clustering = ["EntityID"]

  time_partitioning {
    type  = "DAY"
    field = "Month"
  }

  schema = file("${each.value.schema}")
}
