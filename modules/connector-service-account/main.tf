resource "confluent_kafka_acl" "connector_describe_on_cluster" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${var.service_account_id}"
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
  principal     = "User:${var.service_account_id}"
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
  principal     = "User:${var.service_account_id}"
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
  principal     = "User:${var.service_account_id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
}
