resource "google_project" "terraform_test_ives_8" {
  name            = "Terraform Ives 8"
  project_id      = var.project_id
  billing_account = var.billing_account
  deletion_policy = "DELETE"
}
