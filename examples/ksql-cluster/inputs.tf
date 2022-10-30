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
