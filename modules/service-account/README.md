<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_confluent"></a> [confluent](#requirement\_confluent) | ~> 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_confluent"></a> [confluent](#provider\_confluent) | ~> 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [confluent_api_key.service_account_kafka_api_key](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/api_key) | resource |
| [confluent_role_binding.service_account_for_metrics](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/role_binding) | resource |
| [confluent_service_account.service_account](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_api_version"></a> [cluster\_api\_version](#input\_cluster\_api\_version) | API version of the Kafka cluster. This value cannot be blank if `is_metrics_service_account` is set to `false` | `string` | `null` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The ID of the Kafka cluster. This value cannot be blank if `is_metrics_service_account` is set to `false` | `string` | `null` | no |
| <a name="input_cluster_kind"></a> [cluster\_kind](#input\_cluster\_kind) | The kind of the Kafka cluster. This value cannot be blank if `is_metrics_service_account` is set to `false` | `string` | `null` | no |
| <a name="input_environment_crn"></a> [environment\_crn](#input\_environment\_crn) | The Confluent Resource Name (CRN) of the environment, for example, `crn://confluent.cloud/organization=1111aaaa-11aa-11aa-11aa-111111aaaaaa/environment=env-abc123`. This value cannot be blank if `is_metrics_service_account` is set to `true`. | `string` | `null` | no |
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | The ID of the Confluent environment. This value cannot be blank if `is_metrics_service_account` is set to `false` | `string` | `null` | no |
| <a name="input_is_metrics_service_account"></a> [is\_metrics\_service\_account](#input\_is\_metrics\_service\_account) | Set this value to true if you want to create a service account for metrics export else false | `bool` | `false` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | The name of the service account | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_account_api_version"></a> [service\_account\_api\_version](#output\_service\_account\_api\_version) | An API Version of the schema version of the Service Account, for example, `iam/v2` |
| <a name="output_service_account_id"></a> [service\_account\_id](#output\_service\_account\_id) | The ID of the Service Account |
| <a name="output_service_account_kafka_api_key"></a> [service\_account\_kafka\_api\_key](#output\_service\_account\_kafka\_api\_key) | The ID of the API Key |
| <a name="output_service_account_kafka_api_secret"></a> [service\_account\_kafka\_api\_secret](#output\_service\_account\_kafka\_api\_secret) | The secret of the API Key |
| <a name="output_service_account_kind"></a> [service\_account\_kind](#output\_service\_account\_kind) | A kind of the Service Account, for example, `ServiceAccount`. |
<!-- END_TF_DOCS -->
