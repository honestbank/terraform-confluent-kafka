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

variable "delete_retention_ms" {
  description = "The amount of time to retain delete tombstone markers for log compacted topics."
  type        = string
  default     = null
}

variable "max_compaction_lag_ms" {
  description = "The maximum time a message will remain ineligible for compaction in the log. Only applicable for logs that are being compacted."
  type        = string
  default     = null
}

variable "max_message_bytes" {
  type        = string
  description = "Maximum size of a message in bytes"
  default     = "2097164"
}

variable "message_timestamp_difference_mx_ms" {
  description = <<EOF
    The maximum difference allowed between the timestamp when a broker receives a message and the timestamp specified in the message. If message.timestamp.type=CreateTime, a message will be rejected if the difference in timestamp exceeds this threshold.
    This configuration is ignored if message.timestamp.type=LogAppendTime.
  EOF
  type        = string
  default     = null
}

variable "message_timestamp_type" {
  description = "Define whether the timestamp in the message is message create time or log append time. The value should be either CreateTime or LogAppendTime"
  type        = string
  default     = null
}

variable "min_compaction_lag_ms" {
  description = "The minimum time a message will remain uncompacted in the log. Only applicable for logs that are being compacted."
  type        = string
  default     = null
}

variable "connector_service_account_id" {
  type        = string
  description = "(Required) The ID of the service account managing kafka connector"
}

variable "retention_bytes" {
  description = "This configuration controls the maximum size a partition (which consists of log segments) can grow to before we will discard old log segments to free up space if we are using the “delete” retention policy. By default there is no size limit only a time limit. Since this limit is enforced at the partition level, multiply it by the number of partitions to compute the topic retention in bytes."
  type        = string
  default     = null
}
