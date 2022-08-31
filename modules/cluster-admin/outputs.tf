output "admin_service_account_name" {
  description = "Service Account name to manage Kafka cluster"
  value       = confluent_service_account.admin.display_name
}

output "admin_service_account_id" {
  description = "Service Account ID to manage Kafka cluster"
  value       = confluent_service_account.admin.id
}

output "admin_kafka_api_key" {
  description = "Kafka API Key to manage kafka resources - topics, ACL on topics"
  value       = confluent_api_key.admin_kafka_api_key.id
}

output "admin_kafka_api_secret" {
  description = "Kafka API Secret to manage kafka resources - topics, ACL on topics"
  value       = confluent_api_key.admin_kafka_api_key.secret
  sensitive   = true
}

output "admin_cloud_api_key" {
  description = "Cloud API Key to managing environment resources: clusters, service accounts, and connectors"
  value       = confluent_api_key.admin_cloud_api_key.id
}

output "admin_cloud_api_secret" {
  description = "Cloud API Secret to managing environment resources: clusters, service accounts, and connectors"
  value       = confluent_api_key.admin_cloud_api_key.secret
}
