resource "google_bigquery_table" "monthly_merged_customer_actions" {
  dataset_id = var.dataset_id
  table_id   = "monthly_merged_customer_actions"
  clustering = ["EntityID"]

  time_partitioning {
    type  = "DAY"
    field = "Month"
  }

  schema = jsonencode([
    {
      name = "EntityID"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "Month"
      type = "DATE"
      mode = "NULLABLE"
    },
    {
      name = "Total"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "Category"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "hasChanges"
      type = "BOOLEAN"
      mode = "NULLABLE"
    },
    {
      name = "AboveMaxDate"
      type = "INTEGER"
      mode = "NULLABLE"
    },
  ])
}
