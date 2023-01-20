locals {
  basic_cluster_type     = "basic"
  standard_cluster_type  = "standard"
  dedicated_cluster_type = "dedicated"
}

resource "confluent_kafka_cluster" "cluster" {
  display_name = var.kafka_cluster_name
  availability = var.availability
  cloud        = var.cloud
  region       = var.region

  dynamic "basic" {
    for_each = var.cluster_type == local.basic_cluster_type ? [1] : []
    content {}
  }

  dynamic "standard" {
    for_each = var.cluster_type == local.standard_cluster_type ? [1] : []
    content {}
  }

  dynamic "dedicated" {
    for_each = var.cluster_type == local.dedicated_cluster_type ? [1] : []

    content {
      cku = var.dedicated_cluster_cku
    }
  }
  environment {
    id = var.environment_id
  }
  dynamic "network" {
    for_each = var.cluster_type == local.dedicated_cluster_type ? [1] : []
    content {
      id = var.dedicated_network_id
    }
  }
}
