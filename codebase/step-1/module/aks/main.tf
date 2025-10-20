terraform {
  required_version = ">= 1.10.0"

  required_providers {
    azurerm = {
      version = ">= 4.14.0"
    }
    azuread = {
      version = ">= 3.0.2"
    }
    kubernetes = {
      version = ">= 2.6"
    }
    helm = {
      version = ">= 2.17"
    }
  }
}

locals {
  location = var.location

  k8s_cluster_name   = "${var.resource_name}-aks"
  k8s_cluster_config = azurerm_kubernetes_cluster.k8s.kube_admin_config[0]
  k8s_common_labels  = var.k8s_common_labels

  dns_prefix = (var.dns_prefix == null) ? "${var.name_prefix}-${var.env}" : var.dns_prefix

  k8s_service_endpoints = concat(["Microsoft.KeyVault"], var.k8s_additional_service_endpoints)

  node_resource_group = azurerm_kubernetes_cluster.k8s.node_resource_group
}

data "azurerm_resource_group" "aks" {
  name = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "audit" {
  # name                = "DefaultWorkspace-03124817-ae3a-4193-9790-1725e5f089fe-SUK" 
  name                = "DefaultWorkspace-123f84b9-eb76-4ff5-96f0-e659e666251e-SUK"

  resource_group_name = "DefaultResourceGroup-SUK"
}

data "azurerm_client_config" "current" {}
