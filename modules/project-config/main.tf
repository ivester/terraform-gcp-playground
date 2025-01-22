resource "google_project" "terraform_test_ives_9" {
  name            = "Terraform Ives9"
  project_id      = var.project_id
  billing_account = var.billing_account
  deletion_policy = "DELETE"
}
