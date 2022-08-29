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
| [confluent_role_binding.admin_cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/role_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_api_version"></a> [cluster\_api\_version](#input\_cluster\_api\_version) | The API version of the cluster | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The ID of the cluster | `string` | n/a | yes |
| <a name="input_cluster_kind"></a> [cluster\_kind](#input\_cluster\_kind) | The kind of the cluster | `string` | n/a | yes |
| <a name="input_cluster_rbac_crn"></a> [cluster\_rbac\_crn](#input\_cluster\_rbac\_crn) | Role-based-access-control confluent resource name of the cluster (eg. crn://confluent.cloud/organization=9bb441c4-edef-46ac-8a41-c49e44a3fd9a/environment=env-456xy/cloud-cluster=lkc-123abc/kafka=lkc-123abc) | `string` | n/a | yes |
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | The ID of the environment | `string` | n/a | yes |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | The name of the environment | `string` | n/a | yes |
| <a name="input_environment_resource_name"></a> [environment\_resource\_name](#input\_environment\_resource\_name) | The resource name fo the environment (eg. 	crn://confluent.cloud/organization=9bb441c4-edef-46ac-8a41-c49e44a3fd9a/environment=env=456xy) | `string` | n/a | yes |
| <a name="input_service_account_api_version"></a> [service\_account\_api\_version](#input\_service\_account\_api\_version) | The API version of the service account to grant admin privilege to | `string` | n/a | yes |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | The ID of the service account to grant admin privilege to | `string` | n/a | yes |
| <a name="input_service_account_kind"></a> [service\_account\_kind](#input\_service\_account\_kind) | The kind of the service account to grant admin privilege to | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->