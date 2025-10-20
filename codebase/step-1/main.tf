# // Main Providers and Versions
terraform {
  required_version = "~> 1.10.0"

  required_providers {
    // Require Azure Resource Manager
    azurerm = {
      version = "~> 4.14.0"
    }
    // Require Azure Active Directory
    azuread = {
      version = "~> 3.0.2"
    }
    random = {
      version = "~> 3.6.3"
    }
    null = {
      version = "~> 3.2.3"
    }
    // Require Kubernetes
    kubernetes = {
      version = "~> 2.35.1"
    }
    // Require Helm
    helm = {
      version = "~> 2.17.0"
    }
    # // Require Mongo Atlas Database
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.24.0"
    }
  }
}

# # // Set Local Variable
locals {
  /* Resource name prefix NON PROD environments */
  resource_name = "${var.name_prefix}-${var.env}"

  # /* Resource name prefix PROD environments */
  # resource_name = "${var.name_prefix}-${var.primary_location}"

  /* Global DNS Records */
  dns_resource_group = data.terraform_remote_state.bankifilabs_global.outputs.dns_resource_group_name
  root_domain        = data.terraform_remote_state.bankifilabs_global.outputs.root_domain
  # develop_domain     = "${var.namespace_name}.${var.sub_domain_name}.${var.root_domain}"
  # test_domain        = "test.${var.sub_domain_name}.${var.root_domain}"
  # demo_domain        = "demo.${var.sub_domain_name}.${var.root_domain}"
  # prod_domain        = var.root_domain

#   /* TODO: Do we need Container Register per Workspace ? */
  central_registry_id = data.terraform_remote_state.bankifilabs_central.outputs.container_registry_id

#   /* Tags and K8S labels */
  tags = {
    Environment = var.env
    ManagedBy   = var.managedby
    Owner       = var.owner
    Partner     = var.partner_name
  }

  k8s_common_labels = {
    "app.kubernetes.io/managed-by" = var.managedby
    "app.kubernetes.io/part-of"    = var.owner
    "k8s.bankifi.com/environment"  = var.env
    "k8s.bankifi.com/owner"        = var.owner
    "k8s.bankifi.com/partner"      = var.partner_name
  }
}

# /* Current Clienbt Configuration */
data "azurerm_client_config" "current" {}

# /* Current Subscription */
data "azurerm_subscription" "current" {}

# /* Create a Resource Group fro the Environment */
resource "azurerm_resource_group" "workspace" {
  name     = "${var.name_prefix}-${var.env}-${var.primary_location}"
  location = var.primary_location

  tags = local.tags
}

# /* TODO: Create s Storage Account for ????? */
# resource "azurerm_storage_account" "general" {
#   name                            = "${var.name_prefix}${var.env}${var.primary_location}"
#   resource_group_name             = azurerm_resource_group.workspace.name
#   location                        = azurerm_resource_group.workspace.location
#   account_kind                    = "StorageV2"
#   account_tier                    = "Standard"
#   account_replication_type        = "LRS"
#   https_traffic_only_enabled       = true
#   allow_nested_items_to_be_public = false
#   cross_tenant_replication_enabled = false

#   tags = local.tags
# }

# // Get Central Remote State
data "terraform_remote_state" "bankifilabs_central" {
  backend = "remote"

  config = {
    organization = "BankiFi"
    workspaces = {
      name = "tf-wsp-central"
    }
  }
}

// Get Global Remote State
data "terraform_remote_state" "bankifilabs_global" {
  backend = "remote"

  config = {
    organization = "BankiFi"
    workspaces = {
      name = "tf-wsp-global"
    }
  }
}