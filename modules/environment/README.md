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
| [confluent_environment.env](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/environment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | (Required) Confluent Environment name. The name should be start and end the name with alphanumeric characters and can contain hyphens and underscores. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environment_id"></a> [environment\_id](#output\_environment\_id) | The ID of the Environment |
| <a name="output_environment_name"></a> [environment\_name](#output\_environment\_name) | The display name of the Environment |
| <a name="output_environment_resource_name"></a> [environment\_resource\_name](#output\_environment\_resource\_name) | The resource name of the Environment |
<!-- END_TF_DOCS -->
