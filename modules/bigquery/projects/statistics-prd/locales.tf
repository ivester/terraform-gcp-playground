locals {
  project_id_source = "terraform-test-ives"
  dataset_id        = "presence_portal"
  table_names = {
    impressions  = "monthly_merged_impressions_stats"
    interactions = "monthly_merged_customer_actions"
    top_10_terms = "monthly_merged_top_10_search_term_impressions"
  }
  tables = [
    {
      name   = local.table_names.impressions
      schema = "${path.module}/schema-impressions.json"
    },
    {
      name   = local.table_names.interactions
      schema = "${path.module}/schema-interactions.json"
    },
    {
      name   = local.table_names.top_10_terms
      schema = "${path.module}/schema-top-10-terms.json"
    },

  ]
  data_transfer = [
    {
      name     = local.table_names.impressions
      template = "${path.module}/sync-impressions.tpl"
    },
    {
      name     = local.table_names.interactions
      template = "${path.module}/sync-interactions.tpl"
    },
    {
      name     = local.table_names.top_10_terms
      template = "${path.module}/sync-top-10-terms.tpl"
    },
  ]
  data_transfer_start    = "2025-01-28T10:40:00Z"
  data_transfer_schedule = "every 24 hours"
}

output "config" {
  value = {
    project_id_source      = local.project_id_source
    dataset_id             = local.dataset_id
    tables                 = local.tables
    data_transfer          = local.data_transfer
    data_transfer_start    = local.data_transfer_start
    data_transfer_schedule = local.data_transfer_schedule
  }
}
