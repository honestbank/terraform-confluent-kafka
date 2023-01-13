# locals {
#   build_cluster_type_basic      = var.cluster_for_production ? [] : ["yes"]
#   build_cluster_type_standard   = var.cluster_for_production ? ["yes"] : []
#   build_dedicated_kafka_cluster = var.cluster_for_production ? ["yes"] : []
# }

resource "confluent_kafka_cluster" "cluster" {
  display_name = var.kafka_cluster_name
  availability = var.availability
  cloud        = var.cloud
  region       = var.region

  dynamic "basic" {
    for_each = var.cluster_type == "basic" ? [1] : []
    content {}
  }

  dynamic "standard" {
    for_each = var.cluster_type == "standard" ? [1] : []
    content {}
  }
  dynamic "dedicated" {
    for_each = var.cluster_type == "dedicated" ? [1] : []
    content {
      cku = var.cku
    }
  }
  environment {
    id = var.environment_id
  }
  dynamic "network" {
    for_each = var.cluster_type == "dedicated" ? [1] : []
    content {
      id = var.network_id
    }
  }
}
