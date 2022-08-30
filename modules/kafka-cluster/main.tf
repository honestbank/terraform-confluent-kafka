locals {
  build_cluster_type_basic    = var.cluster_for_production ? [] : ["yes"]
  build_cluster_type_standard = var.cluster_for_production ? ["yes"] : []
}

resource "confluent_kafka_cluster" "cluster" {
  display_name = var.kafka_cluster_name
  availability = var.availability
  cloud        = var.cloud
  region       = var.region

  dynamic "basic" {
    for_each = local.build_cluster_type_basic
    content {}
  }

  dynamic "standard" {
    for_each = local.build_cluster_type_standard
    content {}
  }

  environment {
    id = var.environment_id
  }
}
