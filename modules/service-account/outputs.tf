output "service_account_id" {
  value = confluent_service_account.service_account.id
}

output "service_account_api_version" {
  value = confluent_service_account.service_account.api_version
}

output "service_account_kind" {
  value = confluent_service_account.service_account.kind
}

output "service_account_kafka_api_key" {
  value = confluent_api_key.service_account_kafka_api_key.id
}

output "service_account_kafka_api_secret" {
  value = confluent_api_key.service_account_kafka_api_key.secret
}
