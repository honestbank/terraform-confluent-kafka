resource "null_resource" "enable_schema_registry" {

  triggers = {
    environment_id = var.environment_id
  }

  provisioner "local-exec" {
    command = "curl -sL --http1.1 https://cnfl.io/cli | sh -s -- latest"
  }

  provisioner "local-exec" {
    command = "./bin/confluent version"
  }

  provisioner "local-exec" {
    command = "./bin/confluent login --organization ${var.confluent_organization_id} --save"

    environment = {
      CONFLUENT_CLOUD_EMAIL    = var.confluent_cloud_email
      CONFLUENT_CLOUD_PASSWORD = var.confluent_cloud_password
    }
  }

  provisioner "local-exec" {
    command = "./bin/confluent environment use ${var.environment_id}"
  }
}
