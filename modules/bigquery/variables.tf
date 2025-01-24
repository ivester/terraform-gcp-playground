variable "project_id" {
  description = "The project ID for BigQuery"
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
