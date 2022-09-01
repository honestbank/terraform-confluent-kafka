<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_confluent"></a> [confluent](#requirement\_confluent) | >= 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_confluent"></a> [confluent](#provider\_confluent) | >= 1.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [confluent_kafka_acl.app_connector_read_on_connect_lcc_group](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.connector_create_on_dlq_lcc_topics](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.connector_describe_on_cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.connector_write_on_dlq_lcc_topics](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_service_account.service_account](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kafka_cluster_id"></a> [kafka\_cluster\_id](#input\_kafka\_cluster\_id) | The id of the kafka cluster | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | The name of the service account responsible for managing kafka connector | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connector_service_account_id"></a> [connector\_service\_account\_id](#output\_connector\_service\_account\_id) | n/a |
<!-- END_TF_DOCS -->