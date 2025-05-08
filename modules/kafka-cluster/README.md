<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_confluent"></a> [confluent](#requirement\_confluent) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_confluent"></a> [confluent](#provider\_confluent) | ~> 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [confluent_kafka_cluster.cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability"></a> [availability](#input\_availability) | The availability zone configuration of the Kafka cluster. Accepted values are: `SINGLE_ZONE` and `MULTI_ZONE` | `string` | `"SINGLE_ZONE"` | no |
| <a name="input_cloud"></a> [cloud](#input\_cloud) | The cloud service provider that runs the Kafka cluster. Accepted values are: AWS, AZURE, and GCP | `string` | `"GCP"` | no |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | The value can be either basic, standard, and dedicated. | `string` | `"basic"` | no |
| <a name="input_dedicated_cluster_cku"></a> [dedicated\_cluster\_cku](#input\_dedicated\_cluster\_cku) | The number of Confluent Kafka Units (CKUs) for Dedicated cluster types. The minimum number of CKUs for SINGLE\_ZONE dedicated clusters is 1 whereas MULTI\_ZONE dedicated clusters must have at least 2 CKUs, which means >= 2. | `number` | `1` | no |
| <a name="input_dedicated_network_id"></a> [dedicated\_network\_id](#input\_dedicated\_network\_id) | The Network ID of dedicated cluster for which kafka belongs to. This is only for dedicated cluster setup. | `string` | `null` | no |
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | (Required) The ID of the Environment that the Kafka cluster belongs to, for example, `env-abc123` | `string` | n/a | yes |
| <a name="input_kafka_cluster_name"></a> [kafka\_cluster\_name](#input\_kafka\_cluster\_name) | (Required) The name of the Kafka cluster. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The cloud service provider region where the Kafka cluster is running - see supported list - https://docs.confluent.io/cloud/current/clusters/regions.html#cloud-providers-and-regions | `string` | `"asia-southeast2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bootstrap_endpoint"></a> [bootstrap\_endpoint](#output\_bootstrap\_endpoint) | The bootstrap endpoint used by Kafka clients to connect to the Kafka cluster. (e.g., `SASL_SSL://pkc-00000.us-central1.gcp.confluent.cloud:9092)`. |
| <a name="output_cluster_api_version"></a> [cluster\_api\_version](#output\_cluster\_api\_version) | An API Version of the schema version of the Kafka cluster, for example, `cmk/v2`. |
| <a name="output_cluster_kind"></a> [cluster\_kind](#output\_cluster\_kind) | A kind of the Kafka cluster, for example, `Cluster`. |
| <a name="output_kafka_cluster_id"></a> [kafka\_cluster\_id](#output\_kafka\_cluster\_id) | The ID of the Kafka cluster |
| <a name="output_kafka_cluster_name"></a> [kafka\_cluster\_name](#output\_kafka\_cluster\_name) | The name of the Kafka cluster |
| <a name="output_kafka_cluster_type"></a> [kafka\_cluster\_type](#output\_kafka\_cluster\_type) | Type of Cluster |
| <a name="output_rbac_crn"></a> [rbac\_crn](#output\_rbac\_crn) | The Confluent Resource Name of the Kafka cluster, for example, `crn://confluent.cloud/organization=1111aaaa-11aa-11aa-11aa-111111aaaaaa/environment=env-abc123/cloud-cluster=lkc-abc123`. |
| <a name="output_rest_endpoint"></a> [rest\_endpoint](#output\_rest\_endpoint) | The REST endpoint of the Kafka cluster (e.g., https://pkc-00000.us-central1.gcp.confluent.cloud:443) |
<!-- END_TF_DOCS -->
