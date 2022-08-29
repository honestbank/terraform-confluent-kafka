output "environment_id" {
  value = module.honest_labs_environment.environment_id
}

output "environment_name" {
  value = module.honest_labs_environment.environment_name
}

output "kafka_cluster_basic_name" {
  value = module.honest_labs_kafka_cluster_basic.kafka_cluster_name
}

output "kafka_cluster_basic_bootstrap_endpoint" {
  value = module.honest_labs_kafka_cluster_basic.bootstrap_endpoint
}

output "topic_service_account_key" {
  value = module.honest_labs_topic_service_account.service_account_kafka_api_key
}

output "topic_service_account_secret" {
  value     = module.honest_labs_topic_service_account.service_account_kafka_api_secret
  sensitive = true
}

output "topic_service_account_id" {
  value = module.honest_labs_topic_service_account.service_account_id
}

output "kafka_topic_name" {
  value = module.honest_labs_kafka_topic.topic_name
}
