variable "cluster_rbac_crn" {
  type        = string
  description = "Role-based-access-control confluent resource name of the cluster (eg. crn://confluent.cloud/organization=9bb441c4-edef-46ac-8a41-c49e44a3fd9a/environment=env-456xy/cloud-cluster=lkc-123abc/kafka=lkc-123abc)"
}

variable "cluster_id" {
  type        = string
  description = "The ID of the cluster"
}

variable "cluster_api_version" {
  type        = string
  description = "The API version of the cluster"
}

variable "cluster_kind" {
  type        = string
  description = "The kind of the cluster"
}

variable "environment_id" {
  type        = string
  description = "The ID of the environment"
}

variable "environment_name" {
  type        = string
  description = "The name of the environment"
}

variable "environment_resource_name" {
  type        = string
  description = "The resource name fo the environment (eg. 	crn://confluent.cloud/organization=9bb441c4-edef-46ac-8a41-c49e44a3fd9a/environment=env=456xy)"
}

variable "service_account_id" {
  type = string
  description = "The ID of the service account to grant admin privilege to"
}

variable "service_account_api_version" {
  type = string
  description = "The API version of the service account to grant admin privilege to"
}

variable "service_account_kind" {
  type = string
  description = "The kind of the service account to grant admin privilege to"
}
