variable "environment_id" {
  description = "(Required) The ID of the Environment that the Kafka cluster belongs to, for example, `env-abc123`"
  type        = string
}

variable "confluent_organization_id" {
  type        = string
  description = "(Required) Confluent Organization ID"
}

variable "confluent_cloud_email" {
  type        = string
  description = "(Required) Confluent Cloud Email"
}

variable "confluent_cloud_password" {
  type        = string
  description = "(Required) Confluent Cloud Password"
  sensitive   = true
}
