resource "confluent_connector" "connector" {
  environment {
    id = var.environment_id
  }
  kafka_cluster {
    id = var.cluster_id
  }

  config_sensitive    = var.config_sensitive
  config_nonsensitive = var.config_nonsensitive
}
