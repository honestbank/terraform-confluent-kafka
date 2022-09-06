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

variable "connector_name" {
  type        = string
  description = "(Required) Sets a name for the new connector"
}

variable "connector_class" {
  type        = string
  description = "(Required) Identifies the connector plugin name. See more at https://docs.confluent.io/cloud/current/connectors/overview.html"
}

variable "max_number_of_tasks" {
  type        = string
  description = "Enter the number of tasks to use with the connector. More tasks may improve performance."
  default     = 1
}

variable "topics" {
  type        = list(string)
  description = "(Required) list of topic names"
}

variable "input_data_format" {
  type        = string
  description = "Sets the input message format (data coming from the Kafka topic). Valid entries are `AVRO`, `JSON_SR`, `PROTOBUF`, `JSON`, or `BYTES`. You must have Confluent Cloud Schema Registry configured if using a schema-based message format (for example - Avro, JSON_SR (JSON Schema), or Protobuf)"
}

variable "kafka_auth_mode" {
  type        = string
  description = "(Required) Identifies the connector authentication mode you want to use. There are two options: SERVICE_ACCOUNT or KAFKA_API_KEY"
}

variable "kafka_service_account_id" {
  type        = string
  description = "Identifies the connector authentication mode you want to use. There are two options: SERVICE_ACCOUNT or KAFKA_API_KEY"
  default     = ""
}

variable "kafka_api_key" {
  type        = string
  description = "Kafka API Key"
  default     = ""
}

variable "kafka_api_secret" {
  type        = string
  description = "Kafka API Secret"
  default     = ""
}
