module "honest_labs_environment" {
  source = "../../modules/environment"

  environment_name = "honest-labs-${var.environment}"
}

module "honest_labs_kafka_cluster_basic" {
  source = "../../modules/kafka-cluster"

  environment_id     = module.honest_labs_environment.environment_id
  kafka_cluster_name = "kafka-labs-1-basic-terratest"

  cluster_for_production = false
}

module "admin_privilege_service_account" {
  source = "../../modules/cluster-admin"

  admin_service_account_name = "admin-sa-terratest"
  cluster_api_version        = module.honest_labs_kafka_cluster_basic.cluster_api_version
  cluster_id                 = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  cluster_kind               = module.honest_labs_kafka_cluster_basic.cluster_kind
  cluster_rbac_crn           = module.honest_labs_kafka_cluster_basic.rbac_crn
  environment_id             = module.honest_labs_environment.environment_id
  environment_resource_name  = module.honest_labs_environment.environment_resource_name
}

module "honest_labs_topic_service_account" {
  source = "../../modules/service-account"

  cluster_api_version  = module.honest_labs_kafka_cluster_basic.cluster_api_version
  cluster_id           = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  cluster_kind         = module.honest_labs_kafka_cluster_basic.cluster_kind
  environment_id       = module.honest_labs_environment.environment_id
  service_account_name = "topic-sa-${module.honest_labs_kafka_cluster_basic.kafka_cluster_name}"

  depends_on = [module.admin_privilege_service_account]
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
  depends_on         = [module.admin_privilege_service_account]
}
