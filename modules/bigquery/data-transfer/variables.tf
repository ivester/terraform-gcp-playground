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
