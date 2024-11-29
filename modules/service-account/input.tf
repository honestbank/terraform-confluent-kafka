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

  validation {
    condition     = var.is_metrics_service_account || (var.cluster_id != null && var.cluster_id != "")
    error_message = "The cluster_id cannot be blank when is_metrics_service_account is set to false."
  }
}

variable "cluster_api_version" {
  type        = string
  description = "API version of the Kafka cluster. This value cannot be blank if `is_metrics_service_account` is set to `false`"
  default     = null

  validation {
    condition     = var.is_metrics_service_account || (var.cluster_api_version != null && var.cluster_api_version != "")
    error_message = "The cluster_api_version cannot be blank when is_metrics_service_account is set to false."
  }
}

variable "cluster_kind" {
  type        = string
  description = "The kind of the Kafka cluster. This value cannot be blank if `is_metrics_service_account` is set to `false`"
  default     = null

  validation {
    condition     = var.is_metrics_service_account || (var.cluster_kind != null && var.cluster_kind != "")
    error_message = "The cluster_kind cannot be blank when is_metrics_service_account is set to false."
  }
}

variable "environment_id" {
  type        = string
  description = "The ID of the Confluent environment. This value cannot be blank if `is_metrics_service_account` is set to `false`"
  default     = null

  validation {
    condition     = var.is_metrics_service_account || (var.environment_id != null && var.environment_id != "")
    error_message = "The environment_id cannot be blank when is_metrics_service_account is set to false."
  }
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

  validation {
    condition = (
      var.is_metrics_service_account == false || (
        var.cluster_crn != null &&
        var.cluster_crn != "" &&
        can(regex("^crn://confluent.cloud/organization=[a-f0-9-]+/environment=env-[a-z0-9]+/cloud-cluster=lkc-[a-z0-9]+$", var.cluster_crn))
      )
    )
    error_message = "The 'cluster_crn' must be a valid Confluent Resource Name (CRN) in the format 'crn://confluent.cloud/organization=<UUID>/environment=env-<ID>/cloud-cluster=lkc-<ID>' and cannot be blank if 'is_metrics_service_account' is set to 'true'."
  }
}
