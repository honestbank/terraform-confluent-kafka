<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_confluent"></a> [confluent](#provider\_confluent) | n/a |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [confluent_network.dedicated_kafka_network](https://registry.terraform.io/providers/hashicorp/confluent/latest/docs/resources/network) | resource |
| [confluent_peering.gcp_confluent_peering](https://registry.terraform.io/providers/hashicorp/confluent/latest/docs/resources/peering) | resource |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud"></a> [cloud](#input\_cloud) | The cloud service provider that runs the Kafka cluster. Accepted values are: AWS, AZURE, and GCP | `string` | `"GCP"` | no |
| <a name="input_confluent_cidr_range"></a> [confluent\_cidr\_range](#input\_confluent\_cidr\_range) | The IPv4 CIDR block to used for the network. Must be /16. Required for VPC peering and AWS TransitGateway. | `string` | n/a | yes |
| <a name="input_connection_types"></a> [connection\_types](#input\_connection\_types) | The list of connection types that may be used with the network. Accepted connection types are: PEERING, TRANSITGATEWAY, and PRIVATELINK. | `string` | <pre>[<br>  "PEERING"<br>]</pre> | no |
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | (Required) The ID of the Environment that the Kafka cluster belongs to, for example, `env-abc123` | `string` | n/a | yes |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | The GCP Project ID associated with the Confluent Cloud VPC. | `string` | n/a | yes |
| <a name="input_gcp_vpc_network"></a> [gcp\_vpc\_network](#input\_gcp\_vpc\_network) | The network name of the Confluent Cloud VPC. | `string` | n/a | yes |
| <a name="input_import_custom_routes"></a> [import\_custom\_routes](#input\_import\_custom\_routes) | The Import Custom Routes option enables connectivity to a Confluent Cloud cluster in Google Cloud from customer premise or other clouds, such as AWS and Azure, through a customer VPC that is peered with Confluent Cloud in the same region. Defaults to false | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | The cloud service provider region where the Kafka cluster is running - see supported list - https://docs.confluent.io/cloud/current/clusters/regions.html#cloud-providers-and-regions | `string` | `"asia-southeast2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_confluent_network_id"></a> [confluent\_network\_id](#output\_confluent\_network\_id) | The ID of the Network, for example, n-abc123 |
| <a name="output_confluent_resource_name "></a> [confluent\_resource\_name ](#output\_confluent\_resource\_name ) | The Confluent Resource Name of the Network. |
<!-- END_TF_DOCS -->
