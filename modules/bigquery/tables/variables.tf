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
