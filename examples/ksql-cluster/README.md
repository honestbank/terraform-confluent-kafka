# Confluent Cloud ksqlDB Cluster Example

This example builds a [Confluent Cloud ksqlDB cluster](https://docs.confluent.io/cloud/current/ksqldb/index.html).

### Credentials

Use the following commands to export the required values into environment variables:

```shell
export TF_VAR_confluent_cloud_api_key=$(op item get 'https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=kdhnz4lmfof257q5bvsqoqkbom&i=zsygy4uuxg7mgythbejlgrfr24&h=honestbank.1password.com' --fields label=Key);
export TF_VAR_confluent_cloud_api_secret=$(op item get 'https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=kdhnz4lmfof257q5bvsqoqkbom&i=zsygy4uuxg7mgythbejlgrfr24&h=honestbank.1password.com' --fields label=Secret);
export TF_VAR_confluent_cloud_email=$(op item get 'https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=kdhnz4lmfof257q5bvsqoqkbom&i=4t4pmfe5hs4q6a4fawg6adqoza&h=honestbank.1password.com' --fields label=username);
export TF_VAR_confluent_cloud_password=$(op item get 'https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=kdhnz4lmfof257q5bvsqoqkbom&i=4t4pmfe5hs4q6a4fawg6adqoza&h=honestbank.1password.com' --fields label=password);

# Cannot be retrieved with 1Password, download the file from https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=h72tpqyhfbnfsavtj2bvhpegc4&i=xkliw2jz3n2echyn47derptoy4&h=honestbank.1password.com and run `cat` as follows:
export TF_VAR_google_credentials=$(cat <KEYFILE.json>)

# ❌❌❌ DOES NOT WORK - USE COMMAND ABOVE
export TF_VAR_google_credentials=$(op item get 'https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=h72tpqyhfbnfsavtj2bvhpegc4&i=xkliw2jz3n2echyn47derptoy4&h=honestbank.1password.com' --fields label=Key)
```


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
| <a name="module_ksqldb_cluster"></a> [ksqldb\_cluster](#module\_ksqldb\_cluster) | ../../modules/ksql-cluster | n/a |
| <a name="module_ksqldb_prerequisites"></a> [ksqldb\_prerequisites](#module\_ksqldb\_prerequisites) | ../create-env-cluster-topics | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.ksqldb_cluster_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_confluent_cloud_api_key"></a> [confluent\_cloud\_api\_key](#input\_confluent\_cloud\_api\_key) | Confluent Cloud API Key | `string` | n/a | yes |
| <a name="input_confluent_cloud_api_secret"></a> [confluent\_cloud\_api\_secret](#input\_confluent\_cloud\_api\_secret) | Confluent Cloud API Secret | `string` | n/a | yes |
| <a name="input_confluent_cloud_email"></a> [confluent\_cloud\_email](#input\_confluent\_cloud\_email) | Confluent Cloud Email | `string` | n/a | yes |
| <a name="input_confluent_cloud_password"></a> [confluent\_cloud\_password](#input\_confluent\_cloud\_password) | Confluent Cloud Password | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_version"></a> [api\_version](#output\_api\_version) | The API version of the schema version of the ksqlDB cluster. |
| <a name="output_http_endpoint"></a> [http\_endpoint](#output\_http\_endpoint) | The API endpoint of this ksqlDB cluster. |
| <a name="output_id"></a> [id](#output\_id) | The ksqlDB cluster ID. |
| <a name="output_storage"></a> [storage](#output\_storage) | The amount of storage (in GB) provisioned to this ksqlDB cluster. |
| <a name="output_topic_prefix"></a> [topic\_prefix](#output\_topic\_prefix) | Topic name prefix used by this ksqlDB cluster. |
<!-- END_TF_DOCS -->
