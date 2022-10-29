variable "confluent_streaming_units" {
  description = "A Confluent Streaming Unit is an abstract unit that represents the linearity of performance. For example, if a workload gets a certain level of throughput with 4 CSUs, you can expect about three times the throughput with 12 CSUs. Confluent cloud charges in CSUs per hour. Possible values are 1, 2, 4, 8, 12."
  type        = number
}

variable "display_name" {
  description = "The display name of the ksqlDB cluster."
  type        = string
}

variable "environment_id" {
  description = "The ID of the associated Environment."
  type        = string
}

variable "enable_high_availability" {
  description = "Forces var.confluent_streaming_unit value to 8 if it is set at less than 8."
  type        = bool
}

variable "kafka_cluster_id" {
  description = "The ID of the associated Kafka cluster."
  type        = string
}

variable "service_account_id" {
  description = "The ID of the associated service or user account."
  type        = string
}
