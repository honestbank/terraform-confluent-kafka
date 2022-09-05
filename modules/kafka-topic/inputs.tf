variable "service_account_id" {
  type        = string
  description = "(Required) service account id to grant permission to read/write to topic"
}

variable "cluster_id" {
  type        = string
  description = "(Required) The ID of the cluster"
}

variable "topic_name" {
  type        = string
  description = "(Required) The name of the topic"
}

variable "partition_count" {
  type        = number
  description = "The number of partition of the topic"
  default     = 1
}

variable "retention_ms" {
  type        = string
  description = "The retention time in ms of the topic messages, default is  48 hours"
  default     = "172800000"
}

variable "delete_policy" {
  type        = string
  description = "Delete policy, available values: delete or compact"
  default     = "delete"
}

variable "max_message_bytes" {
  type        = string
  description = "Maximum size of a message in bytes"
  default     = "2097164"
}

variable "consumer_prefix" {
  type        = string
  description = "(Required) The prefix of the consumer group, by default"
}

variable "connector_service_account_id" {
  type        = string
  description = "(Required) The ID of the service account managing kafka connector"
}
