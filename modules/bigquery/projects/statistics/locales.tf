locals {
  project_id_source = "terraform-test-ives"
  dataset_id        = "presence_portal"
  table_names = {
    impressions  = "impressions"
    interactions = "interactions"
    top_10_terms = "top_10_terms"
  }
  tables = [
    {
      name   = local.table_names.impressions
      schema = "${path.module}/schema-${local.table_names.impressions}.json"
    },
    {
      name   = local.table_names.interactions
      schema = "${path.module}/schema-${local.table_names.interactions}.json"
    },
    {
      name   = local.table_names.top_10_terms
      schema = "${path.module}/schema-${local.table_names.top_10_terms}.json"
    },

  ]
  data_transfer = [
    {
      name     = local.table_names.impressions
      template = "${path.module}/sync-${local.table_names.impressions}.tpl"
    },
    {
      name     = local.table_names.interactions
      template = "${path.module}/sync-${local.table_names.interactions}.tpl"
    },
    {
      name     = local.table_names.top_10_terms
      template = "${path.module}/sync-${local.table_names.top_10_terms}.tpl"
    },
  ]
  data_transfer_start    = "2026-01-24T14:05:00Z"
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
