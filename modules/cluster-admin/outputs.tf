output "kafka_api_key" {
  value = confluent_api_key.admin_kafka_api_key.id
}

output "kafka_api_secret" {
  value     = confluent_api_key.admin_kafka_api_key.secret
  sensitive = true
}

output "cloud_api_key" {
  value = confluent_api_key.admin_cloud_api_key.id
}

output "cloud_api_secret" {
  value = confluent_api_key.admin_cloud_api_key.secret
}
