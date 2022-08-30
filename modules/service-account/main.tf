# Random bucket suffix
resource "random_id" "suffix" {
  byte_length = 4
}

resource "confluent_service_account" "service_account" {
  display_name = "${var.service_account_name}-${random_id.suffix.hex}"
  description  = "Service Account with prefix ${var.service_account_name}"
}

resource "confluent_api_key" "service_account_kafka_api_key" {
  display_name = "kafka-api-key-${confluent_service_account.service_account.display_name}"
  description  = "Kafka API Key of topic service account ${confluent_service_account.service_account.display_name}"
  owner {
    id          = confluent_service_account.service_account.id
    api_version = confluent_service_account.service_account.api_version
    kind        = confluent_service_account.service_account.kind
  }

  managed_resource {
    id          = var.cluster_id
    api_version = var.cluster_api_version
    kind        = var.cluster_kind

    environment {
      id = var.environment_id
    }
  }
}
