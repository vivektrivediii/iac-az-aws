resource "azurerm_role_assignment" "k8s_admin_assignment" {
  principal_id         = var.admin_group_id
  scope                = azurerm_kubernetes_cluster.k8s.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
}