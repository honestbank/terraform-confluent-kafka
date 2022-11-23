output "id" {
  description = "The ksqlDB cluster ID."
  value       = module.ksqldb_cluster.id
}

output "api_version" {
  description = "The API version of the schema version of the ksqlDB cluster."
  value       = module.ksqldb_cluster.api_version
}

output "rest_endpoint" {
  description = "The API endpoint of this ksqlDB cluster."
  value       = module.ksqldb_cluster.rest_endpoint
}

output "storage" {
  description = "The amount of storage (in GB) provisioned to this ksqlDB cluster."
  value       = module.ksqldb_cluster.storage
}

output "topic_prefix" {
  description = "Topic name prefix used by this ksqlDB cluster."
  value       = module.ksqldb_cluster.topic_prefix
}
