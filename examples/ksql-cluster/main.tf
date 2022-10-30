module "ksqldb_prerequisites" {
  source = "../create-env-cluster-topics"

  confluent_cloud_api_key    = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
  confluent_cloud_email      = var.confluent_cloud_email
  confluent_cloud_password   = var.confluent_cloud_password
  google_credentials         = ""

  create_bigquery_sink = false
  create_gcs_sink      = false
}

resource "random_id" "ksqldb_cluster_suffix" {
  byte_length = 4
}

module "ksqldb_cluster" {
  source = "../../modules/ksql-cluster"

  display_name              = "ksqldb-example-${random_id.ksqldb_cluster_suffix.hex}"
  confluent_streaming_units = 1
  enable_high_availability  = true
  environment_id            = module.ksqldb_prerequisites.environment_id
  kafka_cluster_id          = module.ksqldb_prerequisites.kafka_cluster_id
  service_account_id        = module.ksqldb_prerequisites.cluster_admin_privilege_service_account_id
}
