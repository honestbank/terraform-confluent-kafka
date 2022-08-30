<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_confluent"></a> [confluent](#requirement\_confluent) | >= 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_confluent"></a> [confluent](#provider\_confluent) | >= 1.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [confluent_api_key.admin_cloud_api_key](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/api_key) | resource |
| [confluent_api_key.admin_kafka_api_key](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/api_key) | resource |
| [confluent_role_binding.admin_cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/role_binding) | resource |
| [confluent_role_binding.admin_environment](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/role_binding) | resource |
| [confluent_service_account.admin](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_service_account_name"></a> [admin\_service\_account\_name](#input\_admin\_service\_account\_name) | The name of the admin service account | `string` | n/a | yes |
| <a name="input_cluster_api_version"></a> [cluster\_api\_version](#input\_cluster\_api\_version) | The API version of the cluster | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The ID of the cluster | `string` | n/a | yes |
| <a name="input_cluster_kind"></a> [cluster\_kind](#input\_cluster\_kind) | The kind of the cluster | `string` | n/a | yes |
| <a name="input_cluster_rbac_crn"></a> [cluster\_rbac\_crn](#input\_cluster\_rbac\_crn) | Role-based-access-control confluent resource name of the cluster (eg. crn://confluent.cloud/organization=9bb441c4-edef-46ac-8a41-c49e44a3fd9a/environment=env-456xy/cloud-cluster=lkc-123abc/kafka=lkc-123abc) | `string` | n/a | yes |
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | The ID of the environment | `string` | n/a | yes |
| <a name="input_environment_resource_name"></a> [environment\_resource\_name](#input\_environment\_resource\_name) | The resource name fo the environment (eg. 	crn://confluent.cloud/organization=9bb441c4-edef-46ac-8a41-c49e44a3fd9a/environment=env=456xy) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_service_account_id"></a> [admin\_service\_account\_id](#output\_admin\_service\_account\_id) | n/a |
| <a name="output_admin_service_account_name"></a> [admin\_service\_account\_name](#output\_admin\_service\_account\_name) | n/a |
| <a name="output_cloud_api_key"></a> [cloud\_api\_key](#output\_cloud\_api\_key) | n/a |
| <a name="output_cloud_api_secret"></a> [cloud\_api\_secret](#output\_cloud\_api\_secret) | n/a |
| <a name="output_kafka_api_key"></a> [kafka\_api\_key](#output\_kafka\_api\_key) | n/a |
| <a name="output_kafka_api_secret"></a> [kafka\_api\_secret](#output\_kafka\_api\_secret) | n/a |
<!-- END_TF_DOCS -->
