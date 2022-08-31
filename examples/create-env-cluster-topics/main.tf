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

module "honest_labs_kafka_topic_example_1" {
  source = "../../modules/kafka-topic"

  // we change to admin kafka api key to create kafka topics.
  providers = {
    confluent = confluent.admin
  }

  cluster_id         = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  consumer_prefix    = "honest_consumer_"
  service_account_id = module.honest_labs_topic_service_account.service_account_id
  topic_name         = "squad-raw.service-example-1.entity"
  depends_on         = [module.admin_privilege_service_account]
}

module "honest_labs_kafka_topic_example_2" {
  source = "../../modules/kafka-topic"

  // we change to admin kafka api key to create kafka topics.
  providers = {
    confluent = confluent.admin
  }

  cluster_id         = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  consumer_prefix    = "honest_consumer_"
  service_account_id = module.honest_labs_topic_service_account.service_account_id
  topic_name         = "squad-raw.service-example-2.entity"
  depends_on         = [module.admin_privilege_service_account]
}

locals {
  topics = [
    module.honest_labs_kafka_topic_example_1.topic_name,
    module.honest_labs_kafka_topic_example_2.topic_name,
  ]
}

module "honest_labs_connector_bigquery_sink" {
  source = "../../modules/connector"

  environment_id = module.honest_labs_environment.environment_id
  cluster_id     = module.honest_labs_kafka_cluster_basic.kafka_cluster_id

  config_nonsensitive = {
    "name" : "confluent-bigquery-sink-test-labs",
    "connector.class" : "BigQuerySink",
    "topics" : join(",", local.topics),
    "kafka.auth.mode" : "KAFKA_API_KEY",
    "project" : "storage-0994",
    "datasets" : "test_poom_bq",
    "input.data.format" : "AVRO",
    "auto.create.tables" : "true",
    "sanitize.topics" : "true",
    "auto.update.schemas" : "true",
    "sanitize.field.names" : "true",
    "tasks.max" : "1",
    "partitioning.type" : "NONE",
    #    "kafka.service.account.id" : module.admin_privilege_service_account.admin_service_account_id,
  }

  config_sensitive = {
    "keyfile" : var.google_credentials,
    "kafka.api.key" : module.honest_labs_topic_service_account.service_account_kafka_api_key,
    "kafka.api.secret" : module.honest_labs_topic_service_account.service_account_kafka_api_secret,
  }
}

module "honest_labs_connector_gcs_sink" {
  source = "../../modules/connector"

  environment_id = module.honest_labs_environment.environment_id
  cluster_id     = module.honest_labs_kafka_cluster_basic.kafka_cluster_id

  config_nonsensitive = {
    "topics" = join(",", local.topics),
    "input.data.format" : "AVRO",
    "connector.class" = "GcsSink"
    "name" : "confluent-gcs-sink-test-labs",
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = module.admin_privilege_service_account.admin_service_account_id
    "gcs.bucket.name"          = "bucket-test"
    "output.data.format"       = "JSON"
    "time.interval"            = "HOURLY"
    "flush.size"               = "1000"
    "tasks.max"                = "1"
    "gcs.credentials.config"   = var.google_credentials
  }

  config_sensitive = {
    "gcs.credentials.config" = var.google_credentials
  }
}
