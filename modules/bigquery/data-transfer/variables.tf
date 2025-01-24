variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "project_id_source" {
  description = "The ID of the GCP project from which to transfer data from"
  type        = string
}

variable "location" {
  description = "The region of the BigQuery dataset"
  type        = string
}

variable "data_transfer_start" {
  description = "When the first data transfer should start"
  type        = string
}

variable "data_transfer_schedule" {
  description = "The schedule for the data transfer"
  type        = string
}

variable "dataset_id" {
  description = "The id of the BigQuery dataset"
  type        = string
}
