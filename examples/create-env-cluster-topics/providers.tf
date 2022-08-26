terraform {
  required_providers {
    confluent = {
      source = "confluentinc/confluent"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

provider "confluent" {
  alias               = "admin"
  kafka_api_key       = module.honest_labs_service_account_admin.service_account_kafka_api_key
  kafka_api_secret    = module.honest_labs_service_account_admin.service_account_kafka_api_secret
  kafka_rest_endpoint = module.honest_labs_kafka_cluster_basic.rest_endpoint
}

