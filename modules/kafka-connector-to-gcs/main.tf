resource "confluent_kafka_acl" "connector_describe_on_cluster" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${var.connector_sa_id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
}

resource "confluent_kafka_acl" "connector_read_target_topic" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = var.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${var.connector_sa_id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
}

resource "confluent_kafka_acl" "app-connector-create-on-dlq-lcc-topics" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.connector_sa_id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
}

resource "confluent_kafka_acl" "app-connector-write-on-dlq-lcc-topics" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.connector_sa_id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
}

resource "confluent_kafka_acl" "app-connector-create-on-success-lcc-topics" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "success-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.connector_sa_id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
}

resource "confluent_kafka_acl" "app-connector-write-on-success-lcc-topics" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "success-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.connector_sa_id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
}

resource "confluent_kafka_acl" "app-connector-create-on-error-lcc-topics" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "error-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.connector_sa_id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
}

resource "confluent_kafka_acl" "app-connector-write-on-error-lcc-topics" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "error-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.connector_sa_id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
}

resource "confluent_kafka_acl" "app-connector-read-on-connect-lcc-group" {
  kafka_cluster {
    id = var.kafka_cluster_id
  }
  resource_type = "GROUP"
  resource_name = "connect-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.connector_sa_id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
}


resource "confluent_connector" "sink" {
  environment {
    id = var.environment_id
  }
  kafka_cluster {
    id = var.kafka_cluster_id
  }

  config_nonsensitive = {
    "topics"                   = var.topic_name
    "input.data.format"        = var.input_data_format
    "connector.class"          = "GcsSink"
    "name"                     = var.connector_name
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = var.connector_sa_id
    "gcs.bucket.name"           = var.gcs_bucket_name
    "output.data.format"       = var.output_data_format
    "time.interval"            = "HOURLY"
    "flush.size"               = "1000"
    "tasks.max"                = "1"
    "gcs.credentials.config" = var.gcs_credentials_config
  }

  depends_on = [
    confluent_kafka_acl.connector_describe_on_cluster,
    confluent_kafka_acl.connector_read_target_topic,
    confluent_kafka_acl.app-connector-create-on-dlq-lcc-topics,
    confluent_kafka_acl.app-connector-write-on-dlq-lcc-topics,
    confluent_kafka_acl.app-connector-create-on-success-lcc-topics,
    confluent_kafka_acl.app-connector-write-on-success-lcc-topics,
    confluent_kafka_acl.app-connector-create-on-error-lcc-topics,
    confluent_kafka_acl.app-connector-write-on-error-lcc-topics,
    confluent_kafka_acl.app-connector-read-on-connect-lcc-group,
  ]
}
