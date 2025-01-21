locals {
  schema_registry_cloud  = "gcp"
  schema_registry_geo    = "apac"
  confluent_cloud_org_id = "137f6bf3-7005-4122-94d2-faf0d17f584c"
}

module "honest_labs_environment" {
  source = "../../modules/environment"

  environment_name = var.environment_name
}

module "enable_schema_registry" {
  source = "../../modules/enable-schema-registry"

  confluent_cloud_email     = var.confluent_cloud_email
  confluent_cloud_password  = var.confluent_cloud_password
  confluent_organization_id = local.confluent_cloud_org_id
  environment_id            = module.honest_labs_environment.environment_id
  schema_registry_cloud     = local.schema_registry_cloud
  schema_registry_geo       = local.schema_registry_geo
}

module "honest_labs_kafka_cluster_basic" {
  source = "../../modules/kafka-cluster"

  environment_id     = module.honest_labs_environment.environment_id
  kafka_cluster_name = var.kafka_cluster_name
  cluster_type       = "basic"
}

module "cluster_admin_privilege_service_account" {
  source = "../../modules/cluster-admin"

  admin_service_account_name = var.admin_service_account_name
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
  service_account_name = var.service_account_name

  depends_on = [module.cluster_admin_privilege_service_account]
}

module "honest_labs_connector_service_account" {
  source               = "../../modules/service-account"
  cluster_api_version  = module.honest_labs_kafka_cluster_basic.cluster_api_version
  cluster_id           = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  cluster_kind         = module.honest_labs_kafka_cluster_basic.cluster_kind
  environment_id       = module.honest_labs_environment.environment_id
  service_account_name = var.connector_service_account_name
}

module "honest_labs_connector_metrics_service_account" {
  source                     = "../../modules/service-account"
  is_metrics_service_account = true
  service_account_name       = "metrics-${var.connector_service_account_name}"
  environment_crn            = module.honest_labs_environment.environment_resource_name
}

module "honest_labs_connector_service_account_grant_permission" {
  source = "../../modules/connector-service-account"

  providers = {
    confluent = confluent.kafka_admin
  }

  kafka_cluster_id   = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  service_account_id = module.honest_labs_connector_service_account.service_account_id
}

module "honest_labs_kafka_topic_example_1" {
  source = "../../modules/kafka-topic"

  // we change to admin kafka api key to create kafka topics.
  providers = {
    confluent = confluent.kafka_admin
  }

  cluster_id                   = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  service_account_id           = module.kafka_topic_service_account.service_account_id
  topic_name                   = var.topic_name_1
  connector_service_account_id = module.honest_labs_connector_service_account.service_account_id

  max_compaction_lag_ms              = "9223372036854775807" # maximum value which is 292271023.05 years.
  delete_retention_ms                = "100"
  message_timestamp_difference_mx_ms = "9223372036854775807"
  min_compaction_lag_ms              = "0"
  retention_bytes                    = "-1"

  depends_on = [module.cluster_admin_privilege_service_account]
}

module "honest_labs_kafka_topic_example_2" {
  source = "../../modules/kafka-topic"

  // we change to admin kafka api key to create kafka topics.
  providers = {
    confluent = confluent.kafka_admin
  }

  cluster_id                   = module.honest_labs_kafka_cluster_basic.kafka_cluster_id
  service_account_id           = module.kafka_topic_service_account.service_account_id
  connector_service_account_id = module.honest_labs_connector_service_account.service_account_id
  topic_name                   = var.topic_name_2
  depends_on                   = [module.cluster_admin_privilege_service_account]
}

locals {
  topics = [
    module.honest_labs_kafka_topic_example_1.topic_name,
    module.honest_labs_kafka_topic_example_2.topic_name,
  ]
}

module "honest_labs_connector_bigquery_sink" {
  count = (var.create_bigquery_sink == true ? 1 : 0)

  source = "../../modules/connector"

  environment_id = module.honest_labs_environment.environment_id
  cluster_id     = module.honest_labs_kafka_cluster_basic.kafka_cluster_id

  connector_class          = "BigQuerySink"
  connector_name           = var.bigquery_connector_name
  input_data_format        = "AVRO"
  topics                   = local.topics
  kafka_auth_mode          = "SERVICE_ACCOUNT"
  kafka_service_account_id = module.honest_labs_connector_service_account.service_account_id
  max_number_of_tasks      = "1"

  config_nonsensitive = {
    "project" : "storage-0994"
    "datasets" : "terratest"
    "auto.create.tables" : "false"
    "sanitize.topics" : "false"
    "auto.update.schemas" : "false"
    "sanitize.field.names" : "false"
    "partitioning.type" : "NONE"
  }

  config_sensitive = {
    "keyfile" : var.google_credentials,
  }

  depends_on = [module.enable_schema_registry]
}

module "honest_labs_connector_gcs_sink" {
  count = (var.create_gcs_sink == true ? 1 : 0)

  source = "../../modules/connector"

  environment_id = module.honest_labs_environment.environment_id
  cluster_id     = module.honest_labs_kafka_cluster_basic.kafka_cluster_id

  connector_class          = "GcsSink"
  connector_name           = var.gcs_connector_name
  input_data_format        = "AVRO"
  topics                   = local.topics
  kafka_auth_mode          = "SERVICE_ACCOUNT"
  kafka_service_account_id = module.honest_labs_connector_service_account.service_account_id
  max_number_of_tasks      = "1"

  config_nonsensitive = {
    "gcs.bucket.name"    = "manual-test-confluent-connector"
    "output.data.format" = "JSON"
    "time.interval"      = "HOURLY"
    "flush.size"         = "1000"
  }

  config_sensitive = {
    "gcs.credentials.config" = var.google_credentials
  }

  depends_on = [module.enable_schema_registry]
}
