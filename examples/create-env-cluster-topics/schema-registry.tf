locals {
  schema_registry_cloud  = "gcp"
  schema_registry_geo    = "apac"
  confluent_cloud_org_id = "137f6bf3-7005-4122-94d2-faf0d17f584c"
}

resource "null_resource" "enable_schema_registry" {

  triggers = {
    environment_id = module.honest_labs_environment.environment_id
  }

  depends_on = [
    module.honest_labs_environment
  ]

  provisioner "local-exec" {
    command = "curl -sL --http1.1 https://cnfl.io/cli | sh -s -- latest"
  }

  provisioner "local-exec" {
    command = "./bin/confluent version"
  }

  #  provisioner "local-exec" {
  #    command = "./bin/confluent schema-registry cluster enable --environment=${module.honest_labs_environment.environment_id} --cloud=${local.schema_registry_cloud} --geo=${local.schema_registry_geo} 1> schema-registry-result.txt 2> schema-registry-error.txt"
  #
  #    environment = {
  #      CONFLUENT_CLOUD_EMAIL    = var.confluent_cloud_email
  #      CONFLUENT_CLOUD_PASSWORD = var.confluent_cloud_password
  #    }
  #  }

  provisioner "local-exec" {
    command = "./bin/confluent login --organization-id ${local.confluent_cloud_org_id} --save"

    environment = {
      CONFLUENT_CLOUD_EMAIL    = var.confluent_cloud_email
      CONFLUENT_CLOUD_PASSWORD = var.confluent_cloud_password
    }
  }

  provisioner "local-exec" {
    command = "./bin/confluent environment use ${module.honest_labs_environment.environment_id}"
  }

  provisioner "local-exec" {
    command = "./bin/confluent schema-registry cluster enable --cloud ${local.schema_registry_cloud} --geo ${local.schema_registry_geo} 1> schema-registry-result.txt 2> schema-registry-error.txt"
  }

  provisioner "local-exec" {
    command = "cat schema-registry-result.txt"
  }

  provisioner "local-exec" {
    command = "cat schema-registry-error.txt"
  }
}
