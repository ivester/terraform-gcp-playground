variable "project_id" {
  description = "The project ID for BigQuery"
  type        = string
}

variable "project_id_source" {
  description = "The ID of the GCP project from which to transfer data from"
  type        = string
}

variable "location" {
  description = "The region for the BigQuery dataset"
  type        = string
}

variable "dataset_id" {
  description = "The id of the BigQuery dataset to create"
  type        = string
}
