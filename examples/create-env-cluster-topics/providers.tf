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


#Error: All 3 kafka_api_key, kafka_api_secret, kafka_rest_endpoint attributes should be set or not set in the provider block at the same time
#│
#│   with provider["registry.terraform.io/confluentinc/confluent"].admin,
#│   on providers.tf line 14, in provider "confluent":
#│   14: provider "confluent" {

provider "confluent" {
  alias               = "kafka_admin"
  kafka_api_key       = module.cluster_admin_privilege_service_account.admin_kafka_api_key
  kafka_api_secret    = module.cluster_admin_privilege_service_account.admin_kafka_api_secret
  kafka_rest_endpoint = module.honest_labs_kafka_cluster_basic.rest_endpoint
  cloud_api_key       = module.cluster_admin_privilege_service_account.admin_cloud_api_key
  cloud_api_secret    = module.cluster_admin_privilege_service_account.admin_cloud_api_secret
}
