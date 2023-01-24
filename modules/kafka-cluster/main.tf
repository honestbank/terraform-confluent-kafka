locals {
  confluent_kafka_cluster_type_basic     = "basic"
  confluent_kafka_cluster_type_standard  = "standard"
  confluent_kafka_cluster_type_dedicated = "dedicated"
}

resource "confluent_kafka_cluster" "cluster" {
  display_name = var.kafka_cluster_name
  availability = var.availability
  cloud        = var.cloud
  region       = var.region

  dynamic "basic" {
    for_each = var.cluster_type == local.confluent_kafka_cluster_type_basic ? [1] : []

    content {}
  }

  dynamic "standard" {
    for_each = var.cluster_type == local.confluent_kafka_cluster_type_standard ? [1] : []

    content {}
  }

  dynamic "dedicated" {
    for_each = var.cluster_type == local.confluent_kafka_cluster_type_dedicated ? [1] : []

    content {
      cku = var.dedicated_cluster_cku
    }
  }

  environment {
    id = var.environment_id
  }

  dynamic "network" {
    for_each = var.cluster_type == local.confluent_kafka_cluster_type_dedicated ? [1] : []

    content {
      id = var.dedicated_network_id
    }
  }
}
