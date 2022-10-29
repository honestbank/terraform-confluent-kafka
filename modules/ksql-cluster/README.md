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
| [confluent_ksql_cluster.ksqldb_cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/ksql_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | The ID of the associated Environment. | `any` | n/a | yes |
| <a name="input_kafka_cluster_id"></a> [kafka\_cluster\_id](#input\_kafka\_cluster\_id) | The ID of the associated Kafka cluster. | `any` | n/a | yes |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | The ID of the associated service or user account. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ksqlDB cluster ID. |
<!-- END_TF_DOCS -->
