variable "project_id" {
  description = "The project ID for BigQuery"
  type        = string
}

variable "location" {
  description = "The region for the BigQuery dataset"
  type        = string
}

variable "config" {
  description = "Configuration Object"
  type = object({
    dataset_id = string    # The ID of the BigQuery dataset
    tables = list(object({ # The list of table configurations
      name   = string
      schema = string
    }))
  })
}
