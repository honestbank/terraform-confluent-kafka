resource "confluent_ksql_cluster" "ksqldb_cluster" {
  display_name = var.display_name

  # 8 CSUs are required for High Availability
  # See https://docs.confluent.io/cloud/current/ksqldb/index.html#high-availability
  csu = ((var.enable_high_availability == true && var.confluent_streaming_units < 8) ? 8 : var.confluent_streaming_units)

  kafka_cluster {
    id = var.kafka_cluster_id
  }
  credential_identity {
    id = var.service_account_id
  }
  environment {
    id = var.environment_id
  }
}
