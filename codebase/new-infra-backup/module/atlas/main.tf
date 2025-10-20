terraform {
  required_version = ">= 1.13.0"

  required_providers {
    azurerm = {
      version = ">= 4.14.0"
    }
    azuread = {
      version = ">= 3.0.2"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = ">= 1.24.0"
    }
  }
}

locals {
  atlas_provider_name = "AZURE"

  atlas_region_map = {
    "uksouth"       = "UK_SOUTH"
    "ukwest"        = "UK_WEST"
    "australiaeast" = "AUSTRALIA_EAST"
    "eastus"        = "US_EAST"
  }
  # atlas_region = local.atlas_region_map[data.azurerm_resource_group.mongodb.location]
  atlas_region = local.atlas_region_map[var.atlas_region]
}

data "azurerm_resource_group" "mongodb" {
  name = var.resource_group_name
}
