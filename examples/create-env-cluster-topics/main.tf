module "honest_labs_environment" {
  source = "../../modules/environment"

  environment_name = "honest-labs"
}

module "honest_labs_kafka_cluster_basic" {
  source = "../../modules/kafka-cluster"

  environment_id     = module.honest_labs_environment.environment_id
  kafka_cluster_name = "kafka-labs-1-basic"

  cluster_for_production = false
}


module "honest_labs_service_account_admin" {
  source = "../../modules/service-account"

  cluster_api_version  = module.honest_labs_kafka_cluster_basic.cluster_api_version
  cluster_id           = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  cluster_kind         = module.honest_labs_kafka_cluster_basic.cluster_kind
  environment_id       = module.honest_labs_environment.environment_id
  service_account_name = "admin-${module.honest_labs_kafka_cluster_basic.kafka_cluster_name}"
}

module "grant-admin-privilege-service-account" {
  source = "../../modules/cluster-admin"

  cluster_api_version         = module.honest_labs_kafka_cluster_basic.cluster_api_version
  cluster_id                  = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  cluster_kind                = module.honest_labs_kafka_cluster_basic.cluster_kind
  environment_id              = module.honest_labs_environment.environment_id
  environment_name            = module.honest_labs_environment.environment_name
  environment_resource_name   = module.honest_labs_environment.environment_resource_name
  cluster_rbac_crn            = module.honest_labs_kafka_cluster_basic.rbac_crn
  service_account_api_version = module.honest_labs_service_account_admin.service_account_api_version
  service_account_id          = module.honest_labs_service_account_admin.service_account_id
  service_account_kind        = module.honest_labs_service_account_admin.service_account_kind
}

module "honest_labs_topic_service_account" {
  source = "../../modules/service-account"

  cluster_api_version  = module.honest_labs_kafka_cluster_basic.cluster_api_version
  cluster_id           = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  cluster_kind         = module.honest_labs_kafka_cluster_basic.cluster_kind
  environment_id       = module.honest_labs_environment.environment_id
  service_account_name = "topic-service-account-${module.honest_labs_kafka_cluster_basic.kafka_cluster_name}"
}

module "honest_labs_kafka_topic" {
  source = "../../modules/kafka-topic"

  // we change to admin kafka api key to create kafka topics.
  providers = {
    confluent = confluent.admin
  }

  cluster_id         = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  consumer_prefix    = "honest_consumer_"
  service_account_id = module.honest_labs_topic_service_account.service_account_id
  topic_name         = "squad-raw.service-example.entity"
}
