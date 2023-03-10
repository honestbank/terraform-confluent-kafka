locals {
  connector_service_account_principal = "User:${var.service_account_id}"
}

resource "confluent_kafka_acl" "connector_describe_on_cluster" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = local.connector_service_account_principal
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
  principal     = local.connector_service_account_principal
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
  principal     = local.connector_service_account_principal
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
  principal     = local.connector_service_account_principal
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
}

# See https://docs.confluent.io/cloud/current/connectors/service-account.html#example-configuring-a-service-account
resource "confluent_kafka_acl" "connector_can_read_topics" {
  for_each = toset(var.topics)
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = each.value
  pattern_type  = "LITERAL"
  principal     = local.connector_service_account_principal
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
}
