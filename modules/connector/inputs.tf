variable "environment_id" {
  description = "(Required) The ID of the Environment that the Kafka cluster belongs to, for example, `env-abc123`"
  type        = string
}

variable "cluster_id" {
  type        = string
  description = "(Required) The ID of the cluster"
}

variable "config_sensitive" {
  type        = map(string)
  description = "Sensitive Config value of connector. See more at https://docs.confluent.io/cloud/current/connectors/overview.html"
  default     = {}
}

variable "config_nonsensitive" {
  type        = map(string)
  description = "Non-Sensitive Config value of connector. See more at https://docs.confluent.io/cloud/current/connectors/overview.html"
  default     = {}
}
