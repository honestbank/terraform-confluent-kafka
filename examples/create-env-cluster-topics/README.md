<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster_admin_privilege_service_account"></a> [cluster\_admin\_privilege\_service\_account](#module\_cluster\_admin\_privilege\_service\_account) | ../../modules/cluster-admin | n/a |
| <a name="module_enable_schema_registry"></a> [enable\_schema\_registry](#module\_enable\_schema\_registry) | ../../modules/enable-schema-registry | n/a |
| <a name="module_honest_labs_connector_bigquery_sink"></a> [honest\_labs\_connector\_bigquery\_sink](#module\_honest\_labs\_connector\_bigquery\_sink) | ../../modules/connector | n/a |
| <a name="module_honest_labs_connector_gcs_sink"></a> [honest\_labs\_connector\_gcs\_sink](#module\_honest\_labs\_connector\_gcs\_sink) | ../../modules/connector | n/a |
| <a name="module_honest_labs_connector_service_account"></a> [honest\_labs\_connector\_service\_account](#module\_honest\_labs\_connector\_service\_account) | ../../modules/service-account | n/a |
| <a name="module_honest_labs_connector_service_account_grant_permission"></a> [honest\_labs\_connector\_service\_account\_grant\_permission](#module\_honest\_labs\_connector\_service\_account\_grant\_permission) | ../../modules/connector-service-account | n/a |
| <a name="module_honest_labs_environment"></a> [honest\_labs\_environment](#module\_honest\_labs\_environment) | ../../modules/environment | n/a |
| <a name="module_honest_labs_kafka_cluster_basic"></a> [honest\_labs\_kafka\_cluster\_basic](#module\_honest\_labs\_kafka\_cluster\_basic) | ../../modules/kafka-cluster | n/a |
| <a name="module_honest_labs_kafka_topic_example_1"></a> [honest\_labs\_kafka\_topic\_example\_1](#module\_honest\_labs\_kafka\_topic\_example\_1) | ../../modules/kafka-topic | n/a |
| <a name="module_honest_labs_kafka_topic_example_2"></a> [honest\_labs\_kafka\_topic\_example\_2](#module\_honest\_labs\_kafka\_topic\_example\_2) | ../../modules/kafka-topic | n/a |
| <a name="module_kafka_topic_service_account"></a> [kafka\_topic\_service\_account](#module\_kafka\_topic\_service\_account) | ../../modules/service-account | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_confluent_cloud_api_key"></a> [confluent\_cloud\_api\_key](#input\_confluent\_cloud\_api\_key) | Confluent Cloud API Key | `string` | n/a | yes |
| <a name="input_confluent_cloud_api_secret"></a> [confluent\_cloud\_api\_secret](#input\_confluent\_cloud\_api\_secret) | Confluent Cloud API Secret | `string` | n/a | yes |
| <a name="input_confluent_cloud_email"></a> [confluent\_cloud\_email](#input\_confluent\_cloud\_email) | Confluent Cloud Email | `string` | n/a | yes |
| <a name="input_confluent_cloud_password"></a> [confluent\_cloud\_password](#input\_confluent\_cloud\_password) | Confluent Cloud Password | `string` | n/a | yes |
| <a name="input_create_bigquery_sink"></a> [create\_bigquery\_sink](#input\_create\_bigquery\_sink) | Controls the creation of the BigQuery sink module. | `bool` | `true` | no |
| <a name="input_create_gcs_sink"></a> [create\_gcs\_sink](#input\_create\_gcs\_sink) | Controls the creation of the GCS sink module. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment/stage | `string` | `"local"` | no |
| <a name="input_google_credentials"></a> [google\_credentials](#input\_google\_credentials) | Google Credentials JSON | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bigquery_connector_id"></a> [bigquery\_connector\_id](#output\_bigquery\_connector\_id) | n/a |
| <a name="output_cluster_admin_privilege_service_account_id"></a> [cluster\_admin\_privilege\_service\_account\_id](#output\_cluster\_admin\_privilege\_service\_account\_id) | The ID of the cluster admin service account. |
| <a name="output_connector_gcs_sink_connector_id"></a> [connector\_gcs\_sink\_connector\_id](#output\_connector\_gcs\_sink\_connector\_id) | n/a |
| <a name="output_environment_id"></a> [environment\_id](#output\_environment\_id) | n/a |
| <a name="output_environment_name"></a> [environment\_name](#output\_environment\_name) | n/a |
| <a name="output_kafka_cluster_basic_bootstrap_endpoint"></a> [kafka\_cluster\_basic\_bootstrap\_endpoint](#output\_kafka\_cluster\_basic\_bootstrap\_endpoint) | n/a |
| <a name="output_kafka_cluster_basic_name"></a> [kafka\_cluster\_basic\_name](#output\_kafka\_cluster\_basic\_name) | n/a |
| <a name="output_kafka_cluster_id"></a> [kafka\_cluster\_id](#output\_kafka\_cluster\_id) | n/a |
| <a name="output_kafka_topic_name"></a> [kafka\_topic\_name](#output\_kafka\_topic\_name) | n/a |
| <a name="output_topic_service_account_id"></a> [topic\_service\_account\_id](#output\_topic\_service\_account\_id) | n/a |
| <a name="output_topic_service_account_key"></a> [topic\_service\_account\_key](#output\_topic\_service\_account\_key) | n/a |
| <a name="output_topic_service_account_secret"></a> [topic\_service\_account\_secret](#output\_topic\_service\_account\_secret) | n/a |
<!-- END_TF_DOCS -->
