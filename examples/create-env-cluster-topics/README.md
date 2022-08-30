<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_admin_privilege_service_account"></a> [admin\_privilege\_service\_account](#module\_admin\_privilege\_service\_account) | ../../modules/cluster-admin | n/a |
| <a name="module_honest_labs_environment"></a> [honest\_labs\_environment](#module\_honest\_labs\_environment) | ../../modules/environment | n/a |
| <a name="module_honest_labs_kafka_cluster_basic"></a> [honest\_labs\_kafka\_cluster\_basic](#module\_honest\_labs\_kafka\_cluster\_basic) | ../../modules/kafka-cluster | n/a |
| <a name="module_honest_labs_kafka_topic"></a> [honest\_labs\_kafka\_topic](#module\_honest\_labs\_kafka\_topic) | ../../modules/kafka-topic | n/a |
| <a name="module_honest_labs_topic_service_account"></a> [honest\_labs\_topic\_service\_account](#module\_honest\_labs\_topic\_service\_account) | ../../modules/service-account | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_confluent_cloud_api_key"></a> [confluent\_cloud\_api\_key](#input\_confluent\_cloud\_api\_key) | Confluent Cloud API Key | `string` | n/a | yes |
| <a name="input_confluent_cloud_api_secret"></a> [confluent\_cloud\_api\_secret](#input\_confluent\_cloud\_api\_secret) | Confluent Cloud API Secret | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment/stage | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environment_id"></a> [environment\_id](#output\_environment\_id) | n/a |
| <a name="output_environment_name"></a> [environment\_name](#output\_environment\_name) | n/a |
| <a name="output_kafka_cluster_basic_bootstrap_endpoint"></a> [kafka\_cluster\_basic\_bootstrap\_endpoint](#output\_kafka\_cluster\_basic\_bootstrap\_endpoint) | n/a |
| <a name="output_kafka_cluster_basic_name"></a> [kafka\_cluster\_basic\_name](#output\_kafka\_cluster\_basic\_name) | n/a |
| <a name="output_kafka_topic_name"></a> [kafka\_topic\_name](#output\_kafka\_topic\_name) | n/a |
| <a name="output_topic_service_account_id"></a> [topic\_service\_account\_id](#output\_topic\_service\_account\_id) | n/a |
| <a name="output_topic_service_account_key"></a> [topic\_service\_account\_key](#output\_topic\_service\_account\_key) | n/a |
| <a name="output_topic_service_account_secret"></a> [topic\_service\_account\_secret](#output\_topic\_service\_account\_secret) | n/a |
<!-- END_TF_DOCS -->
