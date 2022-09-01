variable "service_account_id" {
  type        = string
  description = "The ID of the service account responsible for managing kafka connector"
}

variable "kafka_cluster_id" {
  type        = string
  description = "The id of the kafka cluster"
}
