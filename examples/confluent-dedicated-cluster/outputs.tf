output "environment_id" {
  value = module.honest_labs_environment.environment_id
}

output "confluent_dedicated_cluster_name" {
  value = module.confluent_labs_dedicated_cluster.kafka_cluster_name
}

output "confluent_network_id" {
  value = module.confluent_labs_dedicated_cluster_networking.confluent_network_id
}
