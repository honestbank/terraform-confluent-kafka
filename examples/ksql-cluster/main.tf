module "ksqldb_prerequisites" {
  source = "../create-env-cluster-topics"

  confluent_cloud_api_key    = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
  confluent_cloud_email      = var.confluent_cloud_email
  confluent_cloud_password   = var.confluent_cloud_password
  google_credentials         = var.google_credentials

  create_bigquery_sink = false
  create_gcs_sink      = false
}

module "ksqldb_cluster" {
  source = "../../modules/ksql-cluster"

  environment_id     = module.ksqldb_prerequisites.environment_id
  kafka_cluster_id   = module.ksqldb_prerequisites.kafka_cluster_id
  service_account_id = module.ksqldb_prerequisites.cluster_admin_privilege_service_account_id
}
