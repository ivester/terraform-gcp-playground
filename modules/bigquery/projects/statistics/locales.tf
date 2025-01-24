locals {
  dataset_id = "presence_portal"
  table_names = {
    top_10_terms = "sync_top_10_terms"
    impressions  = "sync_impressions"
    interactions = "sync_interactions"
  }
  data_transfer = [
    {
      name     = local.table_names.top_10_terms
      template = "${path.module}/sync-top-10-terms.tpl"
    },
    {
      name     = local.table_names.impressions
      template = "${path.module}/sync-impressions.tpl"
    },
    {
      name     = local.table_names.interactions
      template = "${path.module}/sync-interactions.tpl"
    }
  ]
}

output "config" {
  value = {
    dataset_id    = local.dataset_id
    data_transfer = local.data_transfer
  }
}
