resource "google_bigquery_table" "monthly_merged_impressions_stats" {
  dataset_id = var.dataset_id
  table_id   = "monthly_merged_impressions_stats"
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
      name = "Branded"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "Unbranded"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "Unspecified"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "FacebookPaidImpressions"
      type = "INTEGER"
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
