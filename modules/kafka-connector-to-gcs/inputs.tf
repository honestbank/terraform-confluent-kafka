variable "kafka_cluster_id" {
  type = string
  description = "The ID of the Kafka cluster"
}

variable "rest_endpoint" {
  type = string
  description = "The rest endpoint of the cluster"
}

variable "connector_sa_id" {
  type = string
  description = "The ID of the service account that will consume from kafka topic"
}

variable "topic_name" {
  type = string
  description = "The name of the topic that will be consumed"
}

variable "environment_id" {
  type = string
  description = "The ID of the environment"
}

variable "gcs_credentials_config" {
  type = string
  description = "The credentials of the service account that has permission to write to gcs"
}

variable "input_data_format" {
  type = string
  description = "The format of the message in the target topic, available values: AVRO, BYTES, JSON, PARQUET"
}

variable "output_data_format" {
  type = string
  description = "The format of the data written in gcs, available values: AVRO, BYTES, JSON, PARQUET"
}

variable "gcs_bucket_name" {
  type = string
  description = "The name of the GCS Bucket to sink to."
}

variable "connector_name" {
  type = string
  description = "The name of the connector"
}

