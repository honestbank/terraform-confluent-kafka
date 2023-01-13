# Confluent ksqlDB Component Module

>
> Note that the `confluent_ksql_cluster` resource used by this module is currently available in **Open Preview**:
>
> confluent_ksql_cluster resource is available in Open Preview for early adopters. Open Preview features are introduced to gather customer feedback. This feature should be used only for evaluation and non-production testing purposes or to provide feedback to Confluent, particularly as it becomes more widely available in follow-on editions.
>
> Open Preview features are intended for evaluation use in development and testing environments only, and not for production use. The warranty, SLA, and Support Services provisions of your agreement with Confluent do not apply to Open Preview features. Open Preview features are considered to be a Proof of Concept as defined in the Confluent Cloud Terms of Service. Confluent may discontinue providing preview releases of the Open Preview features at any time in Confluent’s sole discretion.
>

This module builds a Confluent Cloud ksqlDB cluster based on the [`confluent_ksql_cluster` Resource](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_ksql_cluster).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_confluent"></a> [confluent](#requirement\_confluent) | >= 1.16.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_confluent"></a> [confluent](#provider\_confluent) | >= 1.16.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [confluent_ksql_cluster.ksqldb_cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/ksql_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_confluent_streaming_units"></a> [confluent\_streaming\_units](#input\_confluent\_streaming\_units) | A Confluent Streaming Unit is an abstract unit that represents the linearity of performance. For example, if a workload gets a certain level of throughput with 4 CSUs, you can expect about three times the throughput with 12 CSUs. Confluent cloud charges in CSUs per hour. Possible values are 1, 2, 4, 8, 12. | `number` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name of the ksqlDB cluster. | `string` | n/a | yes |
| <a name="input_enable_high_availability"></a> [enable\_high\_availability](#input\_enable\_high\_availability) | Forces var.confluent\_streaming\_unit value to 8 if it is set at less than 8. | `bool` | n/a | yes |
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | The ID of the associated Environment. | `string` | n/a | yes |
| <a name="input_kafka_cluster_id"></a> [kafka\_cluster\_id](#input\_kafka\_cluster\_id) | The ID of the associated Kafka cluster. | `string` | n/a | yes |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | The ID of the associated service or user account. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The API version of the schema version of the ksqlDB cluster. |
| <a name="output_http_endpoint"></a> [http\_endpoint](#output\_http\_endpoint) | The API endpoint of this ksqlDB cluster. |
| <a name="output_id"></a> [id](#output\_id) | The ksqlDB cluster ID. |
| <a name="output_storage"></a> [storage](#output\_storage) | The amount of storage (in GB) provisioned to this ksqlDB cluster. |
| <a name="output_topic_prefix"></a> [topic\_prefix](#output\_topic\_prefix) | Topic name prefix used by this ksqlDB cluster. |
<!-- END_TF_DOCS -->
