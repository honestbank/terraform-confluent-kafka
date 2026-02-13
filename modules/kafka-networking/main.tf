data "google_compute_zones" "available" {
  region  = var.region
  project = var.gcp_project_id
}

##########################################################
# Setting Up Network for Dedicated Confluent Kafaka cluster
##########################################################

resource "confluent_network" "dedicated_kafka_network" {
  display_name     = var.confluent_network_name
  cloud            = var.cloud
  region           = var.region
  cidr             = var.confluent_cidr_range
  zones            = data.google_compute_zones.available.names
  connection_types = [var.confluent_connection_types]
  environment {
    id = var.environment_id
  }

  lifecycle {
    prevent_destroy = true
  }
}

################################################################################
# Setting Up Confluent-GCP Network Peering for Dedicated Confluent Kafaka cluster
#################################################################################

resource "confluent_peering" "gcp_confluent_peering" {
  display_name = var.confluent_network_peering_name
  gcp {
    project     = var.gcp_project_id
    vpc_network = var.gcp_vpc_network
    #customer_region      = var.region
    import_custom_routes = var.import_custom_routes
  }
  environment {
    id = var.environment_id
  }
  network {
    id = confluent_network.dedicated_kafka_network.id
  }

  lifecycle {
    prevent_destroy = true
  }
}
