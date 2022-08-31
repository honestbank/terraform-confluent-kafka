resource "random_id" "suffix" {
  byte_length = 4
}

module "honest_labs_environment" {
  source = "../../modules/environment"

  environment_name = "labs-environment-${var.environment}-${random_id.suffix.hex}"
}

module "honest_labs_kafka_cluster_basic" {
  source = "../../modules/kafka-cluster"

  environment_id     = module.honest_labs_environment.environment_id
  kafka_cluster_name = "labs-kafka-cluster-${random_id.suffix.hex}"

  cluster_for_production = false
}

module "cluster_admin_privilege_service_account" {
  source = "../../modules/cluster-admin"

  admin_service_account_name = "labs-cluster-admin-sa-${random_id.suffix.hex}"
  cluster_api_version        = module.honest_labs_kafka_cluster_basic.cluster_api_version
  cluster_id                 = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  cluster_kind               = module.honest_labs_kafka_cluster_basic.cluster_kind
  cluster_rbac_crn           = module.honest_labs_kafka_cluster_basic.rbac_crn
  environment_id             = module.honest_labs_environment.environment_id
  environment_resource_name  = module.honest_labs_environment.environment_resource_name
}

module "kafka_topic_service_account" {
  source = "../../modules/service-account"

  cluster_api_version  = module.honest_labs_kafka_cluster_basic.cluster_api_version
  cluster_id           = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  cluster_kind         = module.honest_labs_kafka_cluster_basic.cluster_kind
  environment_id       = module.honest_labs_environment.environment_id
  service_account_name = "labs-topic-sa-${module.honest_labs_kafka_cluster_basic.kafka_cluster_name}"

  depends_on = [module.cluster_admin_privilege_service_account]
}

module "honest_labs_kafka_topic_example_1" {
  source = "../../modules/kafka-topic"

  // we change to admin kafka api key to create kafka topics.
  providers = {
    confluent = confluent.kafka_admin
  }

  cluster_id         = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  consumer_prefix    = "honest_consumer_"
  service_account_id = module.kafka_topic_service_account.service_account_id
  topic_name         = "squad_raw_service_example_1_entity"
  depends_on         = [module.cluster_admin_privilege_service_account]
}

module "honest_labs_kafka_topic_example_2" {
  source = "../../modules/kafka-topic"

  // we change to admin kafka api key to create kafka topics.
  providers = {
    confluent = confluent.kafka_admin
  }

  cluster_id         = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  consumer_prefix    = "honest_consumer_"
  service_account_id = module.kafka_topic_service_account.service_account_id
  topic_name         = "squad_raw_service_example_2_entity"
  depends_on         = [module.cluster_admin_privilege_service_account]
}

locals {
  topics = [
    module.honest_labs_kafka_topic_example_1.topic_name,
    module.honest_labs_kafka_topic_example_2.topic_name,
  ]
}

#module "honest_labs_connector_bigquery_sink" {
#  source = "../../modules/connector"
#
#  environment_id = module.honest_labs_environment.environment_id
#  cluster_id     = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
#
#  connector_class     = "BigQuerySink"
#  connector_name      = "labs-confluent-bigquery-sink-${random_id.suffix.hex}"
#  input_data_format   = "JSON"
#  topics              = local.topics
#  kafka_auth_mode     = "KAFKA_API_KEY"
#  kafka_api_key       = module.kafka_topic_service_account.service_account_kafka_api_key
#  kafka_api_secret    = module.kafka_topic_service_account.service_account_kafka_api_key
#  max_number_of_tasks = "1"
#
#  config_nonsensitive = {
#    "project" : "storage-0994"
#    "datasets" : "terratest"
#    "auto.create.tables" : "false"
#    "sanitize.topics" : "false"
#    "auto.update.schemas" : "false"
#    "sanitize.field.names" : "false"
#    "partitioning.type" : "NONE"
#  }
#
#  config_sensitive = {
#    "keyfile" : var.google_credentials,
#  }
#}

#module "honest_labs_connector_gcs_sink" {
#  source = "../../modules/connector"
#
#  environment_id = module.honest_labs_environment.environment_id
#  cluster_id     = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
#
#  connector_class          = "GcsSink"
#  connector_name           = "labs-confluent-gcs-sink-${random_id.suffix.hex}"
#  input_data_format        = "AVRO"
#  topics                   = local.topics
#  kafka_auth_mode          = "SERVICE_ACCOUNT"
#  kafka_service_account_id = module.admin_privilege_service_account.admin_service_account_id
#  max_number_of_tasks      = "1"
#
#  config_nonsensitive = {
#    "gcs.bucket.name"    = "bucket-test"
#    "output.data.format" = "JSON"
#    "time.interval"      = "HOURLY"
#    "flush.size"         = "1000"
#  }
#
#  config_sensitive = {
#    "gcs.credentials.config" = var.google_credentials
#  }
#}
