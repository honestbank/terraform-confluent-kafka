locals {
  use_api_key = var.kafka_auth_mode == "KAFKA_API_KEY" ? true : false

  config_auth_non_sensitive_api_key = {
    "kafka.auth.mode" : "KAFKA_API_KEY"
  }
  config_auth_sensitive_api_key = {
    "kafka.api.key" : var.kafka_api_key
    "kafka.api.secret" : var.kafka_api_secret
  }

  config_auth_non_sensitive_service_account = {
    "kafka.auth.mode" : "SERVICE_ACCOUNT"
    "kafka.service.account.id" : var.kafka_service_account_id
  }

  #combined all non-sensitive parameters
  default_config_nonsensitive = {
    "name" : var.connector_name,
    "connector.class" : var.connector_class,
    "tasks.max" : var.max_number_of_tasks,
    "topics" : join(",", var.topics),
    "input.data.format" : var.input_data_format,
  }

  config_auth_non_sensitive = local.use_api_key ? local.config_auth_non_sensitive_api_key : local.config_auth_non_sensitive_service_account

  config_nonsensitive = merge(var.config_nonsensitive, merge(local.default_config_nonsensitive, local.config_auth_non_sensitive))

  #combined all sensitive parameters
  config_auth_sensitive = local.use_api_key ? local.config_auth_sensitive_api_key : {}

  config_sensitive = merge(var.config_sensitive, local.config_auth_sensitive)
}

resource "confluent_connector" "connector" {
  environment {
    id = var.environment_id
  }
  kafka_cluster {
    id = var.cluster_id
  }

  config_nonsensitive = local.config_nonsensitive

  config_sensitive = local.config_sensitive
}
