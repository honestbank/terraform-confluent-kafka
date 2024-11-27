locals {
  RESOURCE_TYPE_TOPIC = "TOPIC"
  RESOURCE_TYPE_GROUP = "GROUP"

  PATTERN_TYPE_LITERAL  = "LITERAL"
  PATTERN_TYPE_PREFIXED = "PREFIXED"

  OPERATION_WRITE = "WRITE"
  OPERATION_READ  = "READ"

  PERMISSION_ALLOW = "ALLOW"

  HOST_WILDCARD = "*"
}

resource "confluent_kafka_topic" "topic" {
  kafka_cluster {
    id = var.cluster_id
  }
  topic_name       = var.topic_name
  partitions_count = var.partition_count

  config = {
    "cleanup.policy"                      = var.delete_policy
    "delete.retention.ms"                 = var.delete_retention_ms
    "max.message.bytes"                   = var.max_message_bytes
    "max.compaction.lag.ms"               = var.max_compaction_lag_ms
    "message.timestamp.type"              = var.message_timestamp_type
    "message.timestamp.difference.max.ms" = var.message_timestamp_difference_mx_ms
    "min.compaction.lag.ms"               = var.min_compaction_lag_ms
    "retention.ms"                        = var.retention_ms
    "retention.bytes"                     = var.retention_bytes
  }
}

resource "confluent_kafka_acl" "kafka_acl_write" {
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = local.RESOURCE_TYPE_TOPIC
  resource_name = confluent_kafka_topic.topic.topic_name
  pattern_type  = local.PATTERN_TYPE_LITERAL
  principal     = "User:${var.service_account_id}"
  host          = local.HOST_WILDCARD
  operation     = local.OPERATION_WRITE
  permission    = local.PERMISSION_ALLOW

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_kafka_acl" "kafka_acl_read" {
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = local.RESOURCE_TYPE_TOPIC
  resource_name = confluent_kafka_topic.topic.topic_name
  pattern_type  = local.PATTERN_TYPE_LITERAL
  principal     = "User:${var.service_account_id}"
  host          = local.HOST_WILDCARD
  operation     = local.OPERATION_READ
  permission    = local.PERMISSION_ALLOW

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_kafka_acl" "kafka_acl_consumer" {
  count = var.consumer_prefix != null ? 1 : 0

  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = local.RESOURCE_TYPE_GROUP

  resource_name = var.consumer_prefix
  pattern_type  = local.PATTERN_TYPE_PREFIXED
  principal     = "User:${var.service_account_id}"
  host          = local.HOST_WILDCARD
  operation     = local.OPERATION_READ
  permission    = local.PERMISSION_ALLOW

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_kafka_acl" "connector_read_target_topic" {
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = local.RESOURCE_TYPE_TOPIC
  resource_name = var.topic_name
  pattern_type  = local.PATTERN_TYPE_LITERAL
  principal     = "User:${var.connector_service_account_id}"
  host          = local.HOST_WILDCARD
  operation     = local.OPERATION_READ
  permission    = local.PERMISSION_ALLOW

  lifecycle {
    prevent_destroy = true
  }
}
