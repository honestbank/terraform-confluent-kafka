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
| [confluent_kafka_acl.kafka_acl_consumer](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.kafka_acl_read](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.kafka_acl_write](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_topic.topic](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The ID of the cluster | `string` | n/a | yes |
| <a name="input_consumer_prefix"></a> [consumer\_prefix](#input\_consumer\_prefix) | The prefix of the consumer group, by default | `string` | n/a | yes |
| <a name="input_delete_policy"></a> [delete\_policy](#input\_delete\_policy) | Delete policy, available values: delete or compact | `string` | `"delete"` | no |
| <a name="input_max_message_bytes"></a> [max\_message\_bytes](#input\_max\_message\_bytes) | Maximum size of a message in bytes | `string` | `"2097164"` | no |
| <a name="input_partition_count"></a> [partition\_count](#input\_partition\_count) | The number of partition of the topic | `number` | `1` | no |
| <a name="input_retention_ms"></a> [retention\_ms](#input\_retention\_ms) | The retention time in ms of the topic messages, default is  48 hours | `string` | `"172800000"` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | service account id to grant permission to read/write to topic | `string` | n/a | yes |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | The name of the topic | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_topic_name"></a> [topic\_name](#output\_topic\_name) | n/a |
<!-- END_TF_DOCS -->
