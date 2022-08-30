# Connector Module

Provides a connector resource that enables creating, editing, and deleting connectors on Confluent Cloud.

See config at https://docs.confluent.io/cloud/current/connectors/overview.html

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
| [confluent_connector.connector](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/connector) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | (Required) The ID of the cluster | `string` | n/a | yes |
| <a name="input_config_nonsensitive"></a> [config\_nonsensitive](#input\_config\_nonsensitive) | Non-Sensitive Config value of connector | `map(string)` | `{}` | no |
| <a name="input_config_sensitive"></a> [config\_sensitive](#input\_config\_sensitive) | Sensitive Config value of connector | `map(string)` | `{}` | no |
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | (Required) The ID of the Environment that the Kafka cluster belongs to, for example, `env-abc123` | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connector_id"></a> [connector\_id](#output\_connector\_id) | The ID of the connector |
<!-- END_TF_DOCS -->
