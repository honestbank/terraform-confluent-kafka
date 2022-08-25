variable "service_account_name" {
  type        = string
  description = "The name of the service account"

  validation {
    condition     = length(var.service_account_name) < 65
    error_message = "The Service acocunt name cannot be longer than 64 charaters"
  }

  validation {
    condition     = length(var.service_account_name) > 0
    error_message = "The service account name cannot be empty, currently set to an empty string."
  }

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
