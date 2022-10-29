# Confluent Kafka Module Tests

This folder contains automated tests for the various Confluent Cloud modules in this repo.

## Credentials

The following credentials are needed - details of where to find them and how to set them are provided:

| Description                                | Sourced from env var | Location                                                                                                                                                               |
|--------------------------------------------|----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Confluent Cloud API Key                    | `TERRATEST_CONFLUENT_CLOUD_SEED_KEY` | [1Password link](https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=kdhnz4lmfof257q5bvsqoqkbom&i=zsygy4uuxg7mgythbejlgrfr24&h=honestbank.1password.com) |
| Confluent Cloud API Secret                 | `TERRATEST_CONFLUENT_CLOUD_SEED_SECRET` | [1Password link](https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=kdhnz4lmfof257q5bvsqoqkbom&i=zsygy4uuxg7mgythbejlgrfr24&h=honestbank.1password.com) |
| Confluent Cloud root account email         | `TERRATEST_CONFLUENT_CLOUD_EMAIL` | [1Password link](https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=kdhnz4lmfof257q5bvsqoqkbom&i=4t4pmfe5hs4q6a4fawg6adqoza&h=honestbank.1password.com) |
| Confluent Cloud root account password      | `TERRATEST_CONFLUENT_CLOUD_PASSWORD` | [1Password link](https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=kdhnz4lmfof257q5bvsqoqkbom&i=4t4pmfe5hs4q6a4fawg6adqoza&h=honestbank.1password.com) |
| Google Cloud credentials for BigQuery sink | `TERRATEST_GOOGLE_CREDENTIALS_STORAGE` | [1Password link](https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=h72tpqyhfbnfsavtj2bvhpegc4&i=xkliw2jz3n2echyn47derptoy4&h=honestbank.1password.com) |

### Using the 1Password CLI

Use the following commands to export the required values into environment variables:

```shell
export TERRATEST_CONFLUENT_CLOUD_SEED_KEY=$(op item get 'https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=kdhnz4lmfof257q5bvsqoqkbom&i=zsygy4uuxg7mgythbejlgrfr24&h=honestbank.1password.com' --fields label=Key);
export TERRATEST_CONFLUENT_CLOUD_SEED_SECRET=$(op item get 'https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=kdhnz4lmfof257q5bvsqoqkbom&i=zsygy4uuxg7mgythbejlgrfr24&h=honestbank.1password.com' --fields label=Secret);
export TERRATEST_CONFLUENT_CLOUD_EMAIL=$(op item get 'https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=kdhnz4lmfof257q5bvsqoqkbom&i=4t4pmfe5hs4q6a4fawg6adqoza&h=honestbank.1password.com' --fields label=username);
export TERRATEST_CONFLUENT_CLOUD_PASSWORD=$(op item get 'https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=kdhnz4lmfof257q5bvsqoqkbom&i=4t4pmfe5hs4q6a4fawg6adqoza&h=honestbank.1password.com' --fields label=password);

# Cannot be retrieved with 1Password, download the file from https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=h72tpqyhfbnfsavtj2bvhpegc4&i=xkliw2jz3n2echyn47derptoy4&h=honestbank.1password.com and run `cat` as follows:
export TERRATEST_GOOGLE_CREDENTIALS_STORAGE=$(cat <KEYFILE.json>)

# ❌❌❌ DOES NOT WORK - USE COMMAND ABOVE
export TERRATEST_GOOGLE_CREDENTIALS_STORAGE=$(op item get 'https://start.1password.com/open/i?a=VXS5N4NL2JFYXPI7UPCI6VQCGQ&v=h72tpqyhfbnfsavtj2bvhpegc4&i=xkliw2jz3n2echyn47derptoy4&h=honestbank.1password.com' --fields label=Key)
```
