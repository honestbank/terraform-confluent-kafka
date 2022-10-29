output "bigquery_connector_id" {
  value = try(module.honest_labs_connector_bigquery_sink.0.connector_id, "SINK_NOT_CREATED")
}

output "cluster_admin_privilege_service_account_id" {
  description = "The ID of the cluster admin service account."
  value       = module.cluster_admin_privilege_service_account.admin_service_account_id
}

output "connector_gcs_sink_connector_id" {
  value = try(module.honest_labs_connector_gcs_sink.0.connector_id, "SINK_NOT_CREATED")
}

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

output "kafka_cluster_id" {
  value = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
}

output "kafka_topic_name" {
  value = module.honest_labs_kafka_topic_example_1.topic_name
}

output "topic_service_account_id" {
  value = module.kafka_topic_service_account.service_account_id
}


output "topic_service_account_key" {
  value = module.kafka_topic_service_account.service_account_kafka_api_key
}

output "topic_service_account_secret" {
  value     = module.kafka_topic_service_account.service_account_kafka_api_secret
  sensitive = true
}
