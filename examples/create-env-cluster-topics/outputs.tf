output "environment_id" {
  value = module.honest_labs_environment.environment_id
}

output "environment_name" {
  value = module.honest_labs_environment.environment_name
}

output "kafka_cluster_basic_name" {
  value = module.honest_labs_kafka_cluster_basic.kafka_cluster_name
}

output "kafka_cluster_basic_id" {
  value = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
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

output "topic_service_account_kind" {
  value = module.honest_labs_topic_service_account.service_account_kind
}

output "topic_service_account_api_version" {
  value = module.honest_labs_topic_service_account.service_account_api_version
}

output "kafka_topic_name" {
  value = module.honest_labs_kafka_topic.topic_name
}

output "admin_cloud_api_key" {
  value = module.admin_privilege_service_account.cloud_api_key
}

output "admin_cloud_api_secret" {
  value = module.admin_privilege_service_account.cloud_api_secret
  sensitive = true
}

output "rest_endpoint" {
  value = module.honest_labs_kafka_cluster_basic.rest_endpoint
}
