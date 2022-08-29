output "kafka_cluster_name" {
  description = "The name of the Kafka cluster"
  value       = confluent_kafka_cluster.cluster.display_name
}

output "kafka_cluster_id" {
  description = "The ID of the Kafka cluster"
  value       = confluent_kafka_cluster.cluster.id
}

output "kafka_cluster_type" {
  description = "Type of Cluster"
  value       = (var.cluster_for_production) ? "basic" : "standard"
}

output "bootstrap_endpoint" {
  description = "The bootstrap endpoint used by Kafka clients to connect to the Kafka cluster. (e.g., `SASL_SSL://pkc-00000.us-central1.gcp.confluent.cloud:9092)`."
  value       = confluent_kafka_cluster.cluster.bootstrap_endpoint
}

output "rest_endpoint" {
  description = "The REST endpoint of the Kafka cluster (e.g., https://pkc-00000.us-central1.gcp.confluent.cloud:443)"
  value       = confluent_kafka_cluster.cluster.rest_endpoint
}

output "rbac_crn" {
  description = "The Confluent Resource Name of the Kafka cluster, for example, `crn://confluent.cloud/organization=1111aaaa-11aa-11aa-11aa-111111aaaaaa/environment=env-abc123/cloud-cluster=lkc-abc123`."
  value       = confluent_kafka_cluster.cluster.rbac_crn
}

output "cluster_api_version" {
  description = "An API Version of the schema version of the Kafka cluster, for example, `cmk/v2`."
  value       = confluent_kafka_cluster.cluster.api_version
}

output "cluster_kind" {
  description = "A kind of the Kafka cluster, for example, `Cluster`."
  value       = confluent_kafka_cluster.cluster.kind
}
