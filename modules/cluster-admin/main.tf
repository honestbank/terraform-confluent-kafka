resource "confluent_service_account" "admin" {
  display_name = var.admin_service_account_name
  description  = "Admin Service Account of Cluster ${var.cluster_id} in Environment ${var.environment_id}"
}

resource "confluent_role_binding" "admin_environment" {
  principal   = "User:${confluent_service_account.admin.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = var.environment_resource_name
}

resource "confluent_role_binding" "admin_cluster" {
  principal   = "User:${confluent_service_account.admin.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = var.cluster_rbac_crn
}

resource "confluent_api_key" "admin_kafka_api_key" {
  display_name = "${confluent_service_account.admin.display_name}-kafka-api-key"
  description  = "Kafka API Key that is owned by '${confluent_service_account.admin.display_name}' service account"

  owner {
    id          = confluent_service_account.admin.id
    api_version = confluent_service_account.admin.api_version
    kind        = confluent_service_account.admin.kind
  }

  managed_resource {
    id          = var.cluster_id
    api_version = var.cluster_api_version
    kind        = var.cluster_kind

    environment {
      id = var.environment_id
    }
  }
  depends_on = [
    confluent_role_binding.admin_cluster
  ]
}

resource "confluent_api_key" "admin_cloud_api_key" {
  display_name = "${confluent_service_account.admin.display_name}-cloud-api-key"
  description  = "Cloud API Key that is owned by '${confluent_service_account.admin.display_name}' service account"

  owner {
    id          = confluent_service_account.admin.id
    api_version = confluent_service_account.admin.api_version
    kind        = confluent_service_account.admin.kind
  }

  depends_on = [
    confluent_role_binding.admin_environment
  ]
}
