resource "confluent_service_account" "service_account" {
  display_name = var.service_account_name
  description  = "Kafka Connector Service account of cluster ${var.kafka_cluster_id}"
}

resource "confluent_kafka_acl" "connector_describe_on_cluster" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.service_account.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "connector_create_on_dlq_lcc_topics" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.service_account.id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "connector_write_on_dlq_lcc_topics" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.service_account.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "app_connector_read_on_connect_lcc_group" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "GROUP"
  resource_name = "connect-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.service_account.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
}
