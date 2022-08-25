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
