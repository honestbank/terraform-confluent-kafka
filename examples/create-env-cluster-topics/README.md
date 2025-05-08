<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_confluent"></a> [confluent](#requirement\_confluent) | ~> 2.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster_admin_privilege_service_account"></a> [cluster\_admin\_privilege\_service\_account](#module\_cluster\_admin\_privilege\_service\_account) | ../../modules/cluster-admin | n/a |
| <a name="module_enable_schema_registry"></a> [enable\_schema\_registry](#module\_enable\_schema\_registry) | ../../modules/enable-schema-registry | n/a |
| <a name="module_honest_labs_connector_bigquery_sink"></a> [honest\_labs\_connector\_bigquery\_sink](#module\_honest\_labs\_connector\_bigquery\_sink) | ../../modules/connector | n/a |
| <a name="module_honest_labs_connector_gcs_sink"></a> [honest\_labs\_connector\_gcs\_sink](#module\_honest\_labs\_connector\_gcs\_sink) | ../../modules/connector | n/a |
| <a name="module_honest_labs_connector_metrics_service_account"></a> [honest\_labs\_connector\_metrics\_service\_account](#module\_honest\_labs\_connector\_metrics\_service\_account) | ../../modules/service-account | n/a |
| <a name="module_honest_labs_connector_service_account"></a> [honest\_labs\_connector\_service\_account](#module\_honest\_labs\_connector\_service\_account) | ../../modules/service-account | n/a |
| <a name="module_honest_labs_connector_service_account_grant_permission"></a> [honest\_labs\_connector\_service\_account\_grant\_permission](#module\_honest\_labs\_connector\_service\_account\_grant\_permission) | ../../modules/connector-service-account | n/a |
| <a name="module_honest_labs_environment"></a> [honest\_labs\_environment](#module\_honest\_labs\_environment) | ../../modules/environment | n/a |
| <a name="module_honest_labs_kafka_cluster_basic"></a> [honest\_labs\_kafka\_cluster\_basic](#module\_honest\_labs\_kafka\_cluster\_basic) | ../../modules/kafka-cluster | n/a |
| <a name="module_honest_labs_kafka_topic_example_1"></a> [honest\_labs\_kafka\_topic\_example\_1](#module\_honest\_labs\_kafka\_topic\_example\_1) | ../../modules/kafka-topic | n/a |
| <a name="module_honest_labs_kafka_topic_example_2"></a> [honest\_labs\_kafka\_topic\_example\_2](#module\_honest\_labs\_kafka\_topic\_example\_2) | ../../modules/kafka-topic | n/a |
| <a name="module_kafka_topic_service_account"></a> [kafka\_topic\_service\_account](#module\_kafka\_topic\_service\_account) | ../../modules/service-account | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_service_account_name"></a> [admin\_service\_account\_name](#input\_admin\_service\_account\_name) | Name of the admin service account for the environment | `string` | `"labs-cluster-admin-sa"` | no |
| <a name="input_bigquery_connector_name"></a> [bigquery\_connector\_name](#input\_bigquery\_connector\_name) | Name of the Confluent BigQuery sink connector | `string` | `"labs-confluent-bigquery-sink"` | no |
| <a name="input_confluent_cloud_api_key"></a> [confluent\_cloud\_api\_key](#input\_confluent\_cloud\_api\_key) | Confluent Cloud API Key | `string` | n/a | yes |
| <a name="input_confluent_cloud_api_secret"></a> [confluent\_cloud\_api\_secret](#input\_confluent\_cloud\_api\_secret) | Confluent Cloud API Secret | `string` | n/a | yes |
| <a name="input_confluent_cloud_email"></a> [confluent\_cloud\_email](#input\_confluent\_cloud\_email) | Confluent Cloud Email | `string` | n/a | yes |
| <a name="input_confluent_cloud_password"></a> [confluent\_cloud\_password](#input\_confluent\_cloud\_password) | Confluent Cloud Password | `string` | n/a | yes |
| <a name="input_connector_service_account_name"></a> [connector\_service\_account\_name](#input\_connector\_service\_account\_name) | Name of the service account associated with connector | `string` | `"labs-cluster-connector-sa"` | no |
| <a name="input_create_bigquery_sink"></a> [create\_bigquery\_sink](#input\_create\_bigquery\_sink) | Controls the creation of the BigQuery sink module. | `bool` | `true` | no |
| <a name="input_create_gcs_sink"></a> [create\_gcs\_sink](#input\_create\_gcs\_sink) | Controls the creation of the GCS sink module. | `bool` | `true` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | The name of the Confluent environment (e.g., labs-environment-dev) | `string` | `"labs-environment"` | no |
| <a name="input_gcs_connector_name"></a> [gcs\_connector\_name](#input\_gcs\_connector\_name) | Name of the Confluent GCS sink connector | `string` | `"labs-confluent-gcs-sink"` | no |
| <a name="input_google_credentials"></a> [google\_credentials](#input\_google\_credentials) | Google Credentials JSON | `string` | `""` | no |
| <a name="input_kafka_cluster_name"></a> [kafka\_cluster\_name](#input\_kafka\_cluster\_name) | Name of the Kafka cluster | `string` | `"labs-kafka-cluster"` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the service account | `string` | `"labs-topic-sa"` | no |
| <a name="input_topic_name_1"></a> [topic\_name\_1](#input\_topic\_name\_1) | Name of the first Kafka topic | `string` | `"squad_raw_service_example_1_entity"` | no |
| <a name="input_topic_name_2"></a> [topic\_name\_2](#input\_topic\_name\_2) | Name of the second Kafka topic | `string` | `"squad_raw_service_example_2_entity"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bigquery_connector_id"></a> [bigquery\_connector\_id](#output\_bigquery\_connector\_id) | The ID of the BigQuery sink connector. |
| <a name="output_cluster_admin_privilege_service_account_id"></a> [cluster\_admin\_privilege\_service\_account\_id](#output\_cluster\_admin\_privilege\_service\_account\_id) | The ID of the cluster admin service account. |
| <a name="output_connector_gcs_sink_connector_id"></a> [connector\_gcs\_sink\_connector\_id](#output\_connector\_gcs\_sink\_connector\_id) | The ID of the GCS sink connector. |
| <a name="output_connector_service_account_id"></a> [connector\_service\_account\_id](#output\_connector\_service\_account\_id) | The ID of the service account associated with the Kafka topics. |
| <a name="output_environment_id"></a> [environment\_id](#output\_environment\_id) | The ID of the environment. |
| <a name="output_environment_name"></a> [environment\_name](#output\_environment\_name) | The name of the environment. |
| <a name="output_kafka_cluster_basic_bootstrap_endpoint"></a> [kafka\_cluster\_basic\_bootstrap\_endpoint](#output\_kafka\_cluster\_basic\_bootstrap\_endpoint) | The bootstrap endpoint of the basic Kafka cluster. |
| <a name="output_kafka_cluster_basic_name"></a> [kafka\_cluster\_basic\_name](#output\_kafka\_cluster\_basic\_name) | The name of the Kafka cluster. |
| <a name="output_kafka_cluster_id"></a> [kafka\_cluster\_id](#output\_kafka\_cluster\_id) | The ID of the Kafka cluster. |
| <a name="output_kafka_topic_name_1"></a> [kafka\_topic\_name\_1](#output\_kafka\_topic\_name\_1) | The name of the first Kafka topic. |
| <a name="output_kafka_topic_name_2"></a> [kafka\_topic\_name\_2](#output\_kafka\_topic\_name\_2) | The name of the second Kafka topic. |
| <a name="output_topic_service_account_id"></a> [topic\_service\_account\_id](#output\_topic\_service\_account\_id) | The ID of the service account associated with the Kafka topics. |
| <a name="output_topic_service_account_key"></a> [topic\_service\_account\_key](#output\_topic\_service\_account\_key) | The Kafka API key for the service account. |
| <a name="output_topic_service_account_secret"></a> [topic\_service\_account\_secret](#output\_topic\_service\_account\_secret) | The Kafka API secret for the service account. |
<!-- END_TF_DOCS -->
