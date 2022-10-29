resource "confluent_ksql_cluster" "ksqldb_cluster" {
  display_name = "example"
  csu          = 1
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
