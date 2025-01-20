variable "project_id" {
  description = "The project ID for BigQuery"
  type        = string
}

variable "location" {
  description = "The region for the BigQuery dataset"
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
