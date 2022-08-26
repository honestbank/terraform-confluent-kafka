resource "confluent_kafka_topic" "topic" {
  kafka_cluster {
    id = var.cluster_id
  }
  topic_name       = var.topic_name
  partitions_count = var.partition_count
  config = {
    "cleanup.policy"    = var.delete_policy
    "max.message.bytes" = var.max_message_bytes
    "retention.ms"      = var.retention_ms
  }
}

resource "confluent_kafka_acl" "kafka_acl_write" {
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.topic.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${var.service_account_id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "kafka_acl_read" {
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.topic.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${var.service_account_id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "kafka_acl_consumer" {
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "GROUP"

  resource_name = var.consumer_prefix
  pattern_type  = "PREFIXED"
  principal     = "User:${var.service_account_id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
}
