provider "azurerm" {
  features {}
}

# // Step 10 - Deploy Cluster and Kubernetes Role Assignments, Definitions and Bindings
# provider "mongodbatlas" {
#   public_key  = var.mongodbatlas_public_key
#   private_key = var.mongodbatlas_private_key
# }

# // Step 10 - Deploy Cluster and Kubernetes Role Assignments, Definitions and Bindings
# provider "kubernetes" {
#   host                   = local.k8s_cluster_config.host
#   username               = local.k8s_cluster_config.username
#   password               = local.k8s_cluster_config.password
#   client_certificate     = base64decode(local.k8s_cluster_config.client_certificate)
#   client_key             = base64decode(local.k8s_cluster_config.client_key)
#   cluster_ca_certificate = base64decode(local.k8s_cluster_config.cluster_ca_certificate)
# }

# // Step 10 - Deploy Cluster and Kubernetes Role Assignments, Definitions and Bindings
# provider "helm" {
#   kubernetes {
#     host     = local.k8s_cluster_config.host
#     username = local.k8s_cluster_config.username
#     password = local.k8s_cluster_config.password

#     client_certificate     = base64decode(local.k8s_cluster_config.client_certificate)
#     client_key             = base64decode(local.k8s_cluster_config.client_key)
#     cluster_ca_certificate = base64decode(local.k8s_cluster_config.cluster_ca_certificate)
#   }
# }

# // Step 10 - Deploy Cluster and Kubernetes Role Assignments, Definitions and Bindings
# locals {
#   k8s_cluster_config = module.aks.cluster_admin_config
# }