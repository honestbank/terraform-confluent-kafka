output "environment_id" {
  description = "The ID of the Environment"
  value       = confluent_environment.env.id
}

output "environment_name" {
  description = "The display name of the Environment"
  value       = confluent_environment.env.display_name
}

output "environment_resource_name" {
  description = "The resource name of the Environment"
  value       = confluent_environment.env.resource_name
}
