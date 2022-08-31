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
}

variable "google_sa_credentials" {
  type = string
  description = "google sa credentials json key file"
}
