output "id" {
  description = "The ksqlDB cluster ID."
  value       = confluent_ksql_cluster.ksqldb_cluster.id
}
