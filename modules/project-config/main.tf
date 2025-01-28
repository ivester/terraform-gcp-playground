resource "google_project" "terraform_test_ives_15" {
  name            = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account
}
