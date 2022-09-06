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

variable "schema_registry_cloud" {
  type        = string
  description = "The cloud provider of Schema Registry eg. `aws`, `azure`, or `gcp`."
  default     = "gcp"
}

variable "schema_registry_geo" {
  type        = string
  description = "The geolocation of Schema Registry eg. `us`, `eu`, or `apac`."
  default     = "apac"
}
