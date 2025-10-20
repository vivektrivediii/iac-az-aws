# // Main Providers and Versions
terraform {
  # required_version = "~> 1.10.0"
  required_version = "~> 1.13.2"

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