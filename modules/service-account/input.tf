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
  description = "The ID of the Kafka cluster. This value cannot be blank if `is_metrics_service_account` is set to `false`"
  default     = null
}

variable "cluster_api_version" {
  type        = string
  description = "API version of the Kafka cluster. This value cannot be blank if `is_metrics_service_account` is set to `false`"
  default     = null
}

variable "cluster_kind" {
  type        = string
  description = "The kind of the Kafka cluster. This value cannot be blank if `is_metrics_service_account` is set to `false`"
  default     = null
}

variable "environment_id" {
  type        = string
  description = "The ID of the Confluent environment. This value cannot be blank if `is_metrics_service_account` is set to `false`"
  default     = null
}

variable "is_metrics_service_account" {
  type        = bool
  description = "Set this value to true if you want to create a service account for metrics export else false"
  default     = false
}

variable "cluster_crn" {
  type        = string
  description = "The Confluent Resource Name of the Kafka cluster, for example, `crn://confluent.cloud/organization=1111aaaa-11aa-11aa-11aa-111111aaaaaa/environment=env-abc123/cloud-cluster=lkc-abc123`. This value cannot be blank if `is_metrics_service_account` is set to `true`"
  default     = null
}
