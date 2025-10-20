# provider "azurerm" {
#   features {}
# }
provider "azurerm" {
  features {}
  subscription_id = "03124817-ae3a-4193-9790-1725e5f089fe"
}

provider "azurerm" {
  alias    = "dns"
  subscription_id = "03124817-ae3a-4193-9790-1725e5f089fe"
  features {}
}

provider "azurerm" {
  alias    = "default"
  features {}
}

# # // Step 10 - Deploy Cluster and Kubernetes Role Assignments, Definitions and Bindings
provider "mongodbatlas" {
  public_key  = var.mongodbatlas_public_key
  private_key = var.mongodbatlas_private_key
}


// Step 10 - Deploy Cluster and Kubernetes Role Assignments, Definitions and Bindings
# locals {
#   k8s_cluster_config = module.aks.cluster_admin_config
# }

data "azurerm_kubernetes_cluster" "aks" {
  name                = module.aks.cluster_name
  resource_group_name = azurerm_resource_group.workspace.name

  depends_on          = [module.aks]
}


provider "kubernetes" {
  alias                  = "aks"
  host                   = module.aks.kube_admin_config.host
  client_certificate     = base64decode(module.aks.kube_admin_config.client_certificate)
  client_key             = base64decode(module.aks.kube_admin_config.client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_admin_config.cluster_ca_certificate)
}

provider "helm" {
  alias = "aks"
  kubernetes {
    host                   = module.aks.kube_admin_config.host
    client_certificate     = base64decode(module.aks.kube_admin_config.client_certificate)
    client_key             = base64decode(module.aks.kube_admin_config.client_key)
    cluster_ca_certificate = base64decode(module.aks.kube_admin_config.cluster_ca_certificate)
  }
}
