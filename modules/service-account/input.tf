variable "service_account_name" {
  type        = string
  description = "The name of the service account"
}

variable "cluster_id" {
  type        = string
  description = "The ID of the Kafka cluster"
}

variable "cluster_api_version" {
  type        = string
  description = "API version of the Kafka cluster"
}

variable "cluster_kind" {
  type        = string
  description = "The kind of the Kafka cluster"
}

variable "environment_id" {
  type        = string
  description = "The ID of the Confluent environment"
}
