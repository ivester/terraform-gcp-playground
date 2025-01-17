variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The region of the GCP project"
  type        = string
  default     = "EU"
}

variable "billing_account" {
  description = "The ID of the GCP billing account to use"
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
