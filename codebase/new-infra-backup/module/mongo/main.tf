terraform {
  required_version = ">= 1.13.2"

  required_providers {
    azurerm = {
      version = ">= 4.14.0"
    }
    random = {
      version = ">= 3.6.3"
    }
    null = {
      version = ">= 3.2.3"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = ">= 1.24.0"
    }
  }
}

locals {
  k8s_common_labels = var.k8s_common_labels
  tags              = var.tags

  deployment_settings_map = {
    "Basic" = {
      mongodb_num_shards         = 1
      mongodb_replication_factor = 3
      mongodb_instance_type      = "M10"
      mongodb_backup_enabled     = false
    },
    "Coop" = {
      mongodb_num_shards         = 1
      mongodb_replication_factor = 3
      mongodb_instance_type      = "M10"
      mongodb_backup_enabled     = false
    },
    "Standard" = {
      mongodb_num_shards         = 1
      mongodb_replication_factor = 3
      mongodb_instance_type      = "M40"
      mongodb_backup_enabled     = true
    }
  }
}

data "azurerm_resource_group" "bankifi" {
  name = var.resource_group_name
}

data "mongodbatlas_team" "admin" {
  org_id = var.mongodbatlas_org_id
  name   = var.mongodbatlas_adminteam
}

data "mongodbatlas_team" "developers" {
  for_each = var.env != "prod" ? toset([1]) : toset([])

  org_id = var.mongodbatlas_org_id
  name   = var.mongodbatlas_devteam
}
