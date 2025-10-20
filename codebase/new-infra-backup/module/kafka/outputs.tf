output "k8s_namespace" {
  description = "Kubernetes namespace name"
  value       = kubernetes_namespace.bankifi.id
}

output "dev_group_id" {
  description = "Azure AD Group Id for Developers"
  value       = azuread_group.bankifi_dev_group.object_id
}

# output "node_pool_taint" {
#   value = local.node_pool_taint
# }

# output "mongodb_project_id" {
#   description = "MongoDB Project ID"
#   value       = mongodbatlas_project.platform.id
# }