resource "google_project_service" "data_transfer" {
  project = var.project_id
  service = "bigquerydatatransfer.googleapis.com"
}
