variable "environment_id" {
  description = "(Required) The ID of the Environment that the Kafka cluster belongs to, for example, `env-abc123`"
  type        = string
}

# variable "cluster_for_production" {
#   description = "Is this cluster for production. `false` cluster type is `basic` - for learning and exploring Kafka and Confluent Cloud. `true` cluster type is `standard` for production-ready use cases. Full feature set and standard limits."
#   type        = bool
#   default     = false
# }

variable "kafka_cluster_name" {
  description = "(Required) The name of the Kafka cluster."
  type        = string
}

variable "availability" {
  description = "The availability zone configuration of the Kafka cluster. Accepted values are: `SINGLE_ZONE` and `MULTI_ZONE`"
  type        = string
  default     = "SINGLE_ZONE"
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

variable "cluster_type" {
  description = "The value can be either basic, standard, and dedicated"
  type        = string
  default     = "basic"
}
variable "cku" {
  description = "The number of Confluent Kafka Units (CKUs) for Dedicated cluster types. The minimum number of CKUs for SINGLE_ZONE dedicated clusters is 1 whereas MULTI_ZONE dedicated clusters must have more than 2 CKUs."
  type        = number
  default     = 1
}
variable "network_id" {
  description = "The ID of the Network that the Kafka cluster belongs to"
  type        = string
  default     = null
}
