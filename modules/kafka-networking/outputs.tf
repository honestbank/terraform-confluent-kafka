output "confluent_network_id" {
  description = "The ID of the Network, for example, n-abc123"
  value       = confluent_network.dedicated_kafka_network.id
}

output "confluent_resource_name" {
  description = "The Confluent Resource Name of the Network."
  value       = confluent_network.dedicated_kafka_network.resource_name
}

output "gcp_project_id" {
  description = "The GCP Project ID associated with the Confluent Cloud VPC"
  value       = [for k, v in confluent_network.dedicated_kafka_network.gcp : v.project]
}

output "gcp_vpc_network" {
  description = "The network name of the Confluent Cloud VPC"
  value       = [for k, v in confluent_network.dedicated_kafka_network.gcp : v.vpc_network]
}

output "confluent_peering_id" {
  description = "The ID of the confluent Peering"
  value       = confluent_peering.gcp_confluent_peering.id
}
