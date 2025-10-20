output "cluster_id" {
  value = azurerm_kubernetes_cluster.k8s.id
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.k8s.name
}

output "cluster_admin_config" {
  value     = local.k8s_cluster_config
  sensitive = true
}

output "node_resource_group" {
  value = local.node_resource_group
}

output "cluster_fqdn" {
  value = azurerm_kubernetes_cluster.k8s.fqdn
}

output "client_id" {
  value = azuread_service_principal.k8s_service_principal.client_id
}

output "client_secret" {
  value     = azuread_application_password.k8s_secret.value
  sensitive = true
}

output "principal_id" {
  value = azuread_service_principal.k8s_service_principal.id
}

output "object_id" {
  value = azuread_service_principal.k8s_service_principal.object_id
}

output "vnet_subnet_id" {
  value       = azurerm_subnet.k8s.id
  description = "subnet id for kubernetes subnet"
}

output "log_analytics_workspace_id" {
  value = data.azurerm_log_analytics_workspace.audit.workspace_id
}