provider "google" {
  project = var.project_id
  region  = var.region
}

module "project_config" {
  source = "./modules/project-config"
  project_id      = var.project_id
  project_name    = var.project_name
  billing_account = var.billing_account
}

module "bigquery_statistics_prd" {
  source     = "./modules/bigquery"
  depends_on = [ module.project_config ]
  project_id = var.project_id
}
