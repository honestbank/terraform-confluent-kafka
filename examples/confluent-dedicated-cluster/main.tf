resource "random_id" "suffix" {
  byte_length = 4
}

module "honest_labs_environment" {
  source = "../../modules/environment"

  environment_name = "labs-environment-${var.environment}-${random_id.suffix.hex}"
}
module "confluent_labs_dedicated_cluster_networking" {
  source = "../../modules/kafka-networking"

  environment_id                 = module.honest_labs_environment.environment_id
  confluent_network_name         = "labs-network-${var.environment}-${random_id.suffix.hex}"
  confluent_network_peering_name = "labs-peering-${var.environment}-${random_id.suffix.hex}"
  confluent_cidr_range           = "10.150.0.0/16"
  gcp_project_id                 = "shared-vpc-1bb91cb8"
  gcp_vpc_network                = "honestcard-shared-vpc"
}

module "confluent_labs_dedicated_cluster" {
  source = "../../modules/kafka-cluster"

  environment_id       = module.honest_labs_environment.environment_id
  kafka_cluster_name   = "labs-kafka-dedicated-${var.environment}-${random_id.suffix.hex}"
  cluster_type         = "dedicated"
  dedicated_network_id = module.confluent_labs_dedicated_cluster_networking.confluent_network_id
}
