variable "service_account_name" {
  type = string
  description = "The name of the service account responsible for managing kafka connector"
}

variable "kafka_cluster_id" {
  type = string
  description = "The id of the kafka cluster"
}
