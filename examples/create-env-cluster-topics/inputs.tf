variable "confluent_cloud_api_key" {
  type        = string
  description = "Confluent Cloud API Key"
}

variable "confluent_cloud_api_secret" {
  type        = string
  description = "Confluent Cloud API Secret"
  sensitive   = true
}

variable "environment" {
  type        = string
  description = "Environment/stage"
  default     = "local"
}

variable "google_credentials" {
  type        = string
  sensitive   = true
  description = "Google Credentials JSON"
}
