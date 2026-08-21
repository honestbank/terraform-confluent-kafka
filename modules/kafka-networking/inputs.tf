variable "environment_id" {
  description = "(Required) The ID of the Environment that the Kafka cluster belongs to, for example, `env-abc123`"
  type        = string
}

variable "cloud" {
  description = "The cloud service provider that runs the Kafka cluster. Accepted values are: AWS, AZURE, and GCP"
  type        = string
  default     = "GCP"
}

variable "region" {
  description = "The cloud service provider region where the Kafka cluster is running - see supported list - https://docs.confluent.io/cloud/current/clusters/regions.html#cloud-providers-and-regions"
  type        = string
  default     = "asia-southeast2"
}

variable "confluent_network_name" {
  description = "Network name "
  type        = string
}

variable "confluent_network_peering_name" {
  description = "network peering name"
  type        = string
}
variable "confluent_connection_types" {
  description = " The list of connection types that may be used with the network. Accepted connection types are: PEERING, TRANSITGATEWAY, and PRIVATELINK."
  type        = string
  default     = "PEERING"
  validation {
    condition     = can(regex("^(PEERING|TRANSITGATEWAY|PRIVATELINK)$", var.confluent_connection_types))
    error_message = "Invalid input, only mentioned options can be used: \"PEERING\", \"TRANSITGATEWAY\", \"PRIVATELINK\""
  }
}

variable "confluent_cidr_range" {
  description = "The IPv4 CIDR block to used for the network. Must be /16. Required for VPC peering and AWS TransitGateway."
  type        = string
  validation {
    condition     = can(cidrhost(var.confluent_cidr_range, 16))
    error_message = "Must be valid IPv4 CIDR. and greater than /16"
  }
}

variable "gcp_project_id" {
  description = "The GCP Project ID associated with the Confluent Cloud VPC."
  type        = string
}

variable "gcp_vpc_network" {
  description = "The network name of the Confluent Cloud VPC."
  type        = string
}

variable "import_custom_routes" {
  description = "The Import Custom Routes option enables connectivity to a Confluent Cloud cluster in Google Cloud from customer premise or other clouds, such as AWS and Azure, through a customer VPC that is peered with Confluent Cloud in the same region. Defaults to false"
  type        = bool
  default     = false
}
