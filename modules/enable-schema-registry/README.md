<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.enable_schema_registry](https://registry.terraform.io/providers/hashicorp/null/3.1.1/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_confluent_cloud_email"></a> [confluent\_cloud\_email](#input\_confluent\_cloud\_email) | (Required) Confluent Cloud Email | `string` | n/a | yes |
| <a name="input_confluent_cloud_password"></a> [confluent\_cloud\_password](#input\_confluent\_cloud\_password) | (Required) Confluent Cloud Password | `string` | n/a | yes |
| <a name="input_confluent_organization_id"></a> [confluent\_organization\_id](#input\_confluent\_organization\_id) | (Required) Confluent Organization ID | `string` | n/a | yes |
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | (Required) The ID of the Environment that the Kafka cluster belongs to, for example, `env-abc123` | `string` | n/a | yes |
| <a name="input_schema_registry_cloud"></a> [schema\_registry\_cloud](#input\_schema\_registry\_cloud) | The cloud provider of Schema Registry eg. `aws`, `azure`, or `gcp`. | `string` | `"gcp"` | no |
| <a name="input_schema_registry_geo"></a> [schema\_registry\_geo](#input\_schema\_registry\_geo) | The geolocation of Schema Registry eg. `us`, `eu`, or `apac`. | `string` | `"apac"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
