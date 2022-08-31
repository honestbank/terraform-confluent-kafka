module "honest_labs_environment" {
  source = "../../modules/environment"

  environment_name = "honest-labs-${var.environment}"
}

module "honest_labs_kafka_cluster_basic" {
  source = "../../modules/kafka-cluster"

  environment_id     = module.honest_labs_environment.environment_id
  kafka_cluster_name = "kafka-labs-1-basic"

  cluster_for_production = false
}

module "admin_privilege_service_account" {
  source = "../../modules/cluster-admin"

  admin_service_account_name = "admin-sa"
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

module "service_account_connector_gcs" {
  source = "../../modules/service-account"
  cluster_api_version = module.honest_labs_kafka_cluster_basic.cluster_api_version
  cluster_id = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  cluster_kind = module.honest_labs_kafka_cluster_basic.cluster_kind
  environment_id = module.honest_labs_environment.environment_id
  service_account_name = "sa-connector-gcs"

  depends_on = [module.admin_privilege_service_account]
}


module "freshwork_receiver_service_connector_gcs" {

  source = "../../modules/kafka-connector-to-gcs"

  providers = {
    confluent = confluent.admin_sa
  }

  connector_sa_id        = module.service_account_connector_gcs.service_account_id
  environment_id         = module.honest_labs_environment.environment_id
  gcs_bucket_name        = "kafka-connector-test"
  gcs_credentials_config = file(var.google_sa_credentials)
  input_data_format      = "JSON"
  kafka_cluster_id       = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  output_data_format     = "JSON"
  rest_endpoint          = module.honest_labs_kafka_cluster_basic.rest_endpoint
  topic_name             = module.honest_labs_kafka_topic.topic_name
  connector_name         = "${module.honest_labs_kafka_topic.topic_name}-connector"

  depends_on = [module.service_account_connector_gcs]
}
