resource "google_bigquery_table" "monthly_merged_top_10_search_term_impressions" {
  dataset_id = var.dataset_id
  table_id   = "monthly_merged_top_10_search_term_impressions"
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
      name = "RawSearchTerm"
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
    }
  ])
}
