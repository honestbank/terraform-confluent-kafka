output "service_account_id" {
  description = "The ID of the Service Account"
  value       = confluent_service_account.service_account.id
}

output "service_account_api_version" {
  description = "An API Version of the schema version of the Service Account, for example, `iam/v2`"
  value       = confluent_service_account.service_account.api_version
}

output "service_account_kind" {
  description = "A kind of the Service Account, for example, `ServiceAccount`."
  value       = confluent_service_account.service_account.kind
}

output "service_account_kafka_api_key" {
  description = "The ID of the API Key"
  value       = confluent_api_key.service_account_kafka_api_key.id
}

output "service_account_kafka_api_secret" {
  description = "The secret of the API Key"
  value       = confluent_api_key.service_account_kafka_api_key.secret
  sensitive   = true
}
