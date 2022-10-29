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

variable "environment" {
  type        = string
  description = "Environment/stage"
  default     = "local"
}

variable "google_credentials" {
  default     = ""
  type        = string
  sensitive   = true
  description = "Google Credentials JSON"
}
