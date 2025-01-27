variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "location" {
  description = "The region of the BigQuery dataset"
  type        = string
}

variable "config" {
  description = "Configuration Object"
  type = object({
    project_id_source = string    # The ID of the GCP project from which to transfer data from
    dataset_id        = string    # The ID of the BigQuery dataset
    data_transfer = list(object({ # The list of data transfer configurations
      name     = string
      template = string
    }))
    data_transfer_start    = string # When the first data transfer should start
    data_transfer_schedule = string # The schedule for the data transfer
  })
}
