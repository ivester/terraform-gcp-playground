provider "google" {
  project = var.project_id
  region  = var.region
}

module "project_config" {
  source = "./modules/project_config"

  project_id      = var.project_id
  billing_account = var.billing_account
}

resource "google_project_service" "bigquery" {
  project = module.project_config.project_id
  service = "bigquery.googleapis.com"
  # TODO remove once we are done so things are protected again
  disable_on_destroy         = true
  disable_dependent_services = true
}

resource "google_project_service" "data_transfer" {
  project = module.project_config.project_id
  service = "bigquerydatatransfer.googleapis.com"
  # TODO remove once we are done so things are protected again
  disable_on_destroy         = true
  disable_dependent_services = true
}

resource "google_bigquery_dataset" "presence_portal" {
  depends_on = [
    google_project_service.bigquery,
    google_project_service.data_transfer
  ]
  dataset_id = "presence_portal"
  location   = var.region
}

resource "google_bigquery_table" "monthly_merged_top_10_search_term_impressions" {
  depends_on = [
    google_project_service.bigquery,
    google_project_service.data_transfer
  ]
  dataset_id = google_bigquery_dataset.presence_portal.dataset_id
  table_id   = "monthly_merged_top_10_search_term_impressions"
  clustering = ["EntityID"]
  # TODO remove once we are done so things are protected again
  deletion_protection = false

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

resource "google_bigquery_table" "monthly_merged_impressions_stats" {
  depends_on = [
    google_project_service.bigquery,
    google_project_service.data_transfer
  ]
  dataset_id = google_bigquery_dataset.presence_portal.dataset_id
  table_id   = "monthly_merged_impressions_stats"
  clustering = ["EntityID"]
  # TODO remove once we are done so things are protected again
  deletion_protection = false

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

resource "google_bigquery_table" "monthly_merged_customer_actions" {
  depends_on = [
    google_project_service.bigquery,
    google_project_service.data_transfer
  ]
  dataset_id = google_bigquery_dataset.presence_portal.dataset_id
  table_id   = "monthly_merged_customer_actions"
  clustering = ["EntityID"]
  # TODO remove once we are done so things are protected again
  deletion_protection = false

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

resource "google_bigquery_data_transfer_config" "sync_impressions" {
  display_name   = "Fetch new/updated 'impressions' entries Daily"
  location       = var.region
  data_source_id = "scheduled_query"
  schedule       = var.data_transfer_schedule
  schedule_options {
    start_time = var.data_transfer_start
  }
  params = {
    query = file("./sync-impressions.sql")
  }
}

resource "google_bigquery_data_transfer_config" "sync_interactions" {
  display_name   = "Fetch new/updated 'interactions' entries Daily"
  location       = var.region
  data_source_id = "scheduled_query"
  schedule       = var.data_transfer_schedule
  schedule_options {
    start_time = var.data_transfer_start
  }
  params = {
    query = file("./sync-interactions.sql")
  }
}

resource "google_bigquery_data_transfer_config" "sync_top_10_terms" {
  display_name   = "Fetch new/updated 'top-10-terms' entries Daily"
  location       = var.region
  data_source_id = "scheduled_query"
  schedule       = var.data_transfer_schedule
  schedule_options {
    start_time = var.data_transfer_start
  }
  params = {
    query = file("./sync-top-10-terms.sql")
  }
}
