output "api_version" {
  description = "The API version of the schema version of the ksqlDB cluster."
  value       = confluent_ksql_cluster.ksqldb_cluster.api_version
}

output "rest_endpoint" {
  description = "The API endpoint of this ksqlDB cluster."
  value       = confluent_ksql_cluster.ksqldb_cluster.rest_endpoint
}

output "id" {
  description = "The ksqlDB cluster ID."
  value       = confluent_ksql_cluster.ksqldb_cluster.id
}

output "storage" {
  description = "The amount of storage (in GB) provisioned to this ksqlDB cluster."
  value       = confluent_ksql_cluster.ksqldb_cluster.storage
}

output "topic_prefix" {
  description = "Topic name prefix used by this ksqlDB cluster."
  value       = confluent_ksql_cluster.ksqldb_cluster.topic_prefix
}
