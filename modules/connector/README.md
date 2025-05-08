# Connector Module

Provides a connector resource that enables creating, editing, and deleting connectors on Confluent Cloud.

See config at https://docs.confluent.io/cloud/current/connectors/overview.html

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
| [confluent_connector.connector](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/connector) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | (Required) The ID of the cluster | `string` | n/a | yes |
| <a name="input_config_nonsensitive"></a> [config\_nonsensitive](#input\_config\_nonsensitive) | Non-Sensitive Config value of connector. See more at https://docs.confluent.io/cloud/current/connectors/overview.html | `map(string)` | `{}` | no |
| <a name="input_config_sensitive"></a> [config\_sensitive](#input\_config\_sensitive) | Sensitive Config value of connector. See more at https://docs.confluent.io/cloud/current/connectors/overview.html | `map(string)` | `{}` | no |
| <a name="input_connector_class"></a> [connector\_class](#input\_connector\_class) | (Required) Identifies the connector plugin name. See more at https://docs.confluent.io/cloud/current/connectors/overview.html | `string` | n/a | yes |
| <a name="input_connector_name"></a> [connector\_name](#input\_connector\_name) | (Required) Sets a name for the new connector | `string` | n/a | yes |
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | (Required) The ID of the Environment that the Kafka cluster belongs to, for example, `env-abc123` | `string` | n/a | yes |
| <a name="input_input_data_format"></a> [input\_data\_format](#input\_input\_data\_format) | Sets the input message format (data coming from the Kafka topic). Valid entries are `AVRO`, `JSON_SR`, `PROTOBUF`, `JSON`, or `BYTES`. You must have Confluent Cloud Schema Registry configured if using a schema-based message format (for example - Avro, JSON\_SR (JSON Schema), or Protobuf) | `string` | n/a | yes |
| <a name="input_kafka_api_key"></a> [kafka\_api\_key](#input\_kafka\_api\_key) | Kafka API Key | `string` | `""` | no |
| <a name="input_kafka_api_secret"></a> [kafka\_api\_secret](#input\_kafka\_api\_secret) | Kafka API Secret | `string` | `""` | no |
| <a name="input_kafka_auth_mode"></a> [kafka\_auth\_mode](#input\_kafka\_auth\_mode) | (Required) Identifies the connector authentication mode you want to use. There are two options: SERVICE\_ACCOUNT or KAFKA\_API\_KEY | `string` | n/a | yes |
| <a name="input_kafka_service_account_id"></a> [kafka\_service\_account\_id](#input\_kafka\_service\_account\_id) | Identifies the connector authentication mode you want to use. There are two options: SERVICE\_ACCOUNT or KAFKA\_API\_KEY | `string` | `""` | no |
| <a name="input_max_number_of_tasks"></a> [max\_number\_of\_tasks](#input\_max\_number\_of\_tasks) | Enter the number of tasks to use with the connector. More tasks may improve performance. | `string` | `1` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | (Required) list of topic names | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connector_id"></a> [connector\_id](#output\_connector\_id) | The ID of the connector |
<!-- END_TF_DOCS -->
