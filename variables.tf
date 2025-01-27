variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "project_name" {
  description = "The name of the GCP project"
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
