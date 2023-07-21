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
| [confluent_kafka_acl.connector_read_target_topic](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.kafka_acl_consumer](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.kafka_acl_read](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.kafka_acl_write](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_topic.topic](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | (Required) The ID of the cluster | `string` | n/a | yes |
| <a name="input_connector_service_account_id"></a> [connector\_service\_account\_id](#input\_connector\_service\_account\_id) | (Required) The ID of the service account managing kafka connector | `string` | n/a | yes |
| <a name="input_consumer_prefix"></a> [consumer\_prefix](#input\_consumer\_prefix) | The prefix of the consumer group, meant for the consumer access control. By default no access control for consumers. | `string` | `null` | no |
| <a name="input_delete_policy"></a> [delete\_policy](#input\_delete\_policy) | Delete policy, available values: delete or compact | `string` | `"delete"` | no |
| <a name="input_delete_retention_ms"></a> [delete\_retention\_ms](#input\_delete\_retention\_ms) | The amount of time to retain delete tombstone markers for log compacted topics. | `string` | `null` | no |
| <a name="input_max_compaction_lag_ms"></a> [max\_compaction\_lag\_ms](#input\_max\_compaction\_lag\_ms) | The maximum time a message will remain ineligible for compaction in the log. Only applicable for logs that are being compacted. | `string` | `null` | no |
| <a name="input_max_message_bytes"></a> [max\_message\_bytes](#input\_max\_message\_bytes) | Maximum size of a message in bytes | `string` | `"2097164"` | no |
| <a name="input_message_timestamp_difference_mx_ms"></a> [message\_timestamp\_difference\_mx\_ms](#input\_message\_timestamp\_difference\_mx\_ms) | The maximum difference allowed between the timestamp when a broker receives a message and the timestamp specified in the message. If message.timestamp.type=CreateTime, a message will be rejected if the difference in timestamp exceeds this threshold.<br>    This configuration is ignored if message.timestamp.type=LogAppendTime. | `string` | `null` | no |
| <a name="input_message_timestamp_type"></a> [message\_timestamp\_type](#input\_message\_timestamp\_type) | Define whether the timestamp in the message is message create time or log append time. The value should be either CreateTime or LogAppendTime | `string` | `null` | no |
| <a name="input_min_compaction_lag_ms"></a> [min\_compaction\_lag\_ms](#input\_min\_compaction\_lag\_ms) | The minimum time a message will remain uncompacted in the log. Only applicable for logs that are being compacted. | `string` | `null` | no |
| <a name="input_partition_count"></a> [partition\_count](#input\_partition\_count) | The number of partition of the topic | `number` | `1` | no |
| <a name="input_retention_bytes"></a> [retention\_bytes](#input\_retention\_bytes) | This configuration controls the maximum size a partition (which consists of log segments) can grow to before we will discard old log segments to free up space if we are using the “delete” retention policy. By default there is no size limit only a time limit. Since this limit is enforced at the partition level, multiply it by the number of partitions to compute the topic retention in bytes. | `string` | `null` | no |
| <a name="input_retention_ms"></a> [retention\_ms](#input\_retention\_ms) | The retention time in ms of the topic messages, default is  48 hours | `string` | `"172800000"` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | (Required) service account id to grant permission to read/write to topic | `string` | n/a | yes |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | (Required) The name of the topic | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_topic_id"></a> [topic\_id](#output\_topic\_id) | The ID of the Kafka topic, in the format `<Kafka cluster ID>/<Kafka Topic name>`, for example, `lkc-abc123/topic-1`. |
| <a name="output_topic_name"></a> [topic\_name](#output\_topic\_name) | The name of the topic |
<!-- END_TF_DOCS -->
