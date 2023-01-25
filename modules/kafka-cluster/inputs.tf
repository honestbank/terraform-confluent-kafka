variable "environment_id" {
  description = "(Required) The ID of the Environment that the Kafka cluster belongs to, for example, `env-abc123`"
  type        = string
}
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
  description = "The value can be either basic, standard, and dedicated."
  type        = string
  default     = "basic"
  validation {
    condition     = can(regex("^(basic|standard|dedicated)$", var.cluster_type))
    error_message = "Invalid input, only mentioned options can be used: \"basic\", \"standard\", \"dedicated\""
  }
}

variable "dedicated_cluster_cku" {
  description = "The number of Confluent Kafka Units (CKUs) for Dedicated cluster types. The minimum number of CKUs for SINGLE_ZONE dedicated clusters is 1 whereas MULTI_ZONE dedicated clusters must have at least 2 CKUs, which means >= 2."
  type        = number
  default     = 1
  validation {
    condition     = var.dedicated_cluster_cku > 0
    error_message = "Invalid input, Input value should be greater than 0"
  }
}

variable "dedicated_network_id" {
  description = "The Network ID of dedicated cluster for which kafka belongs to. This is only for dedicated cluster setup."
  type        = string
  default     = null
}
