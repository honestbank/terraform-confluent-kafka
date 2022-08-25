output "kafka_cluster_name" {
  description = "The name of the Kafka cluster"
  value       = (var.cluster_for_production) ? confluent_kafka_cluster.standard.0.display_name : confluent_kafka_cluster.basic.0.display_name
}

output "kafka_cluster_id" {
  description = "The ID of the Kafka cluster"
  value       = (var.cluster_for_production) ? confluent_kafka_cluster.standard.0.id : confluent_kafka_cluster.basic.0.id
}

output "kafka_cluster_type" {
  description = "Type of Cluster"
  value       = (var.cluster_for_production) ? "basic" : "standard"
}

output "bootstrap_endpoint" {
  description = "The bootstrap endpoint used by Kafka clients to connect to the Kafka cluster. (e.g., `SASL_SSL://pkc-00000.us-central1.gcp.confluent.cloud:9092)`."
  value       = (var.cluster_for_production) ? confluent_kafka_cluster.standard.0.bootstrap_endpoint : confluent_kafka_cluster.basic.0.bootstrap_endpoint
}

output "rest_endpoint" {
  description = "The REST endpoint of the Kafka cluster (e.g., https://pkc-00000.us-central1.gcp.confluent.cloud:443)"
  value       = (var.cluster_for_production) ? confluent_kafka_cluster.standard.0.rest_endpoint : confluent_kafka_cluster.basic.0.rest_endpoint
}

output "rbac_crn" {
  description = "The Confluent Resource Name of the Kafka cluster, for example, `crn://confluent.cloud/organization=1111aaaa-11aa-11aa-11aa-111111aaaaaa/environment=env-abc123/cloud-cluster=lkc-abc123`."
  value       = (var.cluster_for_production) ? confluent_kafka_cluster.standard.0.rbac_crn : confluent_kafka_cluster.basic.0.rbac_crn
}

output "cluster_api_version" {
  description = "An API Version of the schema version of the Kafka cluster, for example, `cmk/v2`."
  value       = (var.cluster_for_production) ? confluent_kafka_cluster.standard.0.api_version : confluent_kafka_cluster.basic.0.api_version
}

output "cluster_kind" {
  description = "A kind of the Kafka cluster, for example, `Cluster`."
  value       = (var.cluster_for_production) ? confluent_kafka_cluster.standard.0.kind : confluent_kafka_cluster.basic.0.kind
}
