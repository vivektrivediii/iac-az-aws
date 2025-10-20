# resource "helm_release" "aad_pod_identity" {
#   provider   = helm.aks 
#   name       = "aad-pod-identity"
#   repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
#   chart      = "aad-pod-identity"
#   namespace  = "kube-system"
#   version    = var.aad_pod_identity_version

# }
# resource "helm_release" "aad_pod_identity" {
#   provider   = helm.aks
#   name       = "aad-pod-identity"
#   repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
#   chart      = "aad-pod-identity"
#   namespace  = "kube-system"
#   version    = var.aad_pod_identity_version
#   depends_on = [data.azurerm_kubernetes_cluster.aks]
# #   depends_on = [azurerm_kubernetes_cluster.aks] 
# #   depends_on = [azurerm_kubernetes_cluster.aks] 

# #   depends_on = [module.aks] # ensures AKS is ready before helm runs
# }
variable "aad_pod_identity_version" {
  description = "Chart version for the AAD Pod Identity"
  type        = string
  default     = "4.1.8"
}

resource "helm_release" "aad_pod_identity" {
  provider   = helm.aks
  name       = "aad-pod-identity"
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart      = "aad-pod-identity"
  namespace  = "kube-system"
  version    = var.aad_pod_identity_version
#   depends_on = [azurerm_kubernetes_cluster.aks]
  depends_on = [module.aks] 
#   depends_on = [data.azurerm_kubernetes_cluster.aks]
}
