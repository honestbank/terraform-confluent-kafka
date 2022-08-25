locals {
  build_cluster_type_basic    = (var.cluster_for_production) ? 0 : 1
  build_cluster_type_standard = (var.cluster_for_production) ? 1 : 0
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "confluent_kafka_cluster" "basic" {
  count = local.build_cluster_type_basic

  display_name = "${var.kafka_cluster_name}-${random_id.suffix.hex}"
  availability = var.availability
  cloud        = var.cloud
  region       = var.region

  basic {}

  environment {
    id = var.environment_id
  }
}

resource "confluent_kafka_cluster" "standard" {
  count = local.build_cluster_type_standard

  display_name = "${var.kafka_cluster_name}-${random_id.suffix.hex}"
  availability = var.availability
  cloud        = var.cloud
  region       = var.region

  standard {}

  environment {
    id = var.environment_id
  }
}
