variable "confluent_cloud_api_key" {
  type        = string
  description = "Confluent Cloud API Key"
}

variable "confluent_cloud_api_secret" {
  type        = string
  description = "Confluent Cloud API Secret"
  sensitive   = true
}

variable "confluent_cloud_email" {
  type        = string
  description = "Confluent Cloud Email"
}

variable "confluent_cloud_password" {
  type        = string
  description = "Confluent Cloud Password"
  sensitive   = true
}

variable "create_bigquery_sink" {
  default     = true
  description = "Controls the creation of the BigQuery sink module."
  type        = bool
}

variable "create_gcs_sink" {
  default     = true
  description = "Controls the creation of the GCS sink module."
  type        = bool
}

variable "google_credentials" {
  default     = ""
  type        = string
  sensitive   = true
  description = "Google Credentials JSON"
}

variable "environment_name" {
  description = "The name of the Confluent environment (e.g., labs-environment-dev)"
  type        = string
  default     = "labs-environment"
}

variable "admin_service_account_name" {
  description = "Name of the admin service account for the environment"
  type        = string
  default     = "labs-cluster-admin-sa"
}

variable "service_account_name" {
  description = "Name of the service account"
  type        = string
  default     = "labs-topic-sa"
}

variable "connector_service_account_name" {
  description = "Name of the service account associated with connector"
  type        = string
  default     = "labs-cluster-connector-sa"
}

variable "kafka_cluster_name" {
  description = "Name of the Kafka cluster"
  type        = string
  default     = "labs-kafka-cluster"
}

variable "topic_name_1" {
  description = "Name of the first Kafka topic"
  type        = string
  default     = "squad_raw_service_example_1_entity"
}

variable "topic_name_2" {
  description = "Name of the second Kafka topic"
  type        = string
  default     = "squad_raw_service_example_2_entity"
}

variable "bigquery_connector_name" {
  description = "Name of the Confluent BigQuery sink connector"
  type        = string
  default     = "labs-confluent-bigquery-sink"
}

variable "gcs_connector_name" {
  description = "Name of the Confluent GCS sink connector"
  type        = string
  default     = "labs-confluent-gcs-sink"
}
