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
