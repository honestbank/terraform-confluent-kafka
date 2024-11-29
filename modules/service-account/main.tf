resource "confluent_service_account" "service_account" {
  display_name = var.service_account_name
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

  dynamic "managed_resource" {
    # Create managed_resource only if we are not creating a metrics service account
    for_each = var.is_metrics_service_account ? [] : [true]
    content {
      id          = var.cluster_id
      api_version = var.cluster_api_version
      kind        = var.cluster_kind

      environment {
        id = var.environment_id
      }
    }
  }
}

resource "confluent_role_binding" "service_account_for_metrics" {
  count       = var.is_metrics_service_account ? 1 : 0
  principal   = "User:${confluent_service_account.service_account.id}"
  role_name   = "MetricsViewer"
  crn_pattern = var.cluster_crn
}
