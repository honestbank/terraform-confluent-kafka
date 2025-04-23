data "external" "schema_registry_info" {
  program = ["bash", "${path.module}/grep_result.sh"]
}

output "cluster_id" {
  value = data.external.schema_registry_info.result["cluster"]
}

output "endpoint" {
  value = data.external.schema_registry_info.result["endpoint"]
}

output "region" {
  value = data.external.schema_registry_info.result["region"]
}

output "package" {
  value = data.external.schema_registry_info.result["package"]
}
