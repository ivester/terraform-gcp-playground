resource "google_project" "terraform_test_ives_7" {
  name            = "Terraform Ives 7"
  project_id      = var.project_id
  billing_account = var.billing_account
  deletion_policy = "DELETE"
}
