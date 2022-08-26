resource "confluent_role_binding" "admin_cluster" {
  principal   = "User:${var.service_account_id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = var.cluster_rbac_crn
}
