# terraform {
#   required_version = ">= 1.10.0"

#   required_providers {
#     azurerm = {
#       version = ">= 4.14.0"
#     }
#     azuread = {
#       version = ">= 3.0.2"
#     }
#     random = {
#       version = ">= 3.6.3"
#     }
#     null = {
#       version = ">= 3.2.3"
#     }
#     kubernetes = {
#       version = ">= 2.35.1"
#     }
#     mongodbatlas = {
#       source  = "mongodb/mongodbatlas"
#       version = ">= 1.24.0"
#     }
#   }
# }

locals {
  k8s_cluster_id    = var.k8s_cluster_id
  k8s_common_labels = var.k8s_common_labels
  tags              = var.tags

  deployment_settings_map = {
    "Basic" = {
      kafka_enabled        = true
      kafka_capacity       = 1
      kafka_zone_redundant = false

      cdn_enabled = false

      mongodb_num_shards         = 1
      mongodb_replication_factor = 3
      mongodb_instance_type      = "M10"
      mongodb_backup_enabled     = false
    },
    "Coop" = {
      kafka_enabled        = false
      kafka_capacity       = 1
      kafka_zone_redundant = false

      cdn_enabled = false

      mongodb_num_shards         = 1
      mongodb_replication_factor = 3
      mongodb_instance_type      = "M10"
      mongodb_backup_enabled     = false
    },
    "Standard" = {
      kafka_enabled        = true
      kafka_capacity       = 2
      kafka_zone_redundant = var.zone_redundant
      
      cdn_enabled = true

      mongodb_num_shards         = 1
      mongodb_replication_factor = 3
      mongodb_instance_type      = "M40"
      mongodb_backup_enabled     = true
    }
  }

  cdn_enabled = var.storage_account_name != null && local.deployment_settings_map[var.deployment].cdn_enabled

  // Node pool taint for a multi node pool environment type
  node_pool_taint = var.node_pool_taint
}

data "azurerm_resource_group" "bankifi" {
  name = var.resource_group_name
}

resource "kubernetes_namespace" "bankifi" {
  metadata {
    labels = merge(local.k8s_common_labels, {
      "azure-key-vault-env-injection" = "enabled"
    })
    name = var.namespace_name
  }
}

data "azurerm_storage_account" "general" {
  count = local.cdn_enabled ? 1 : 0

  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

# resource "azurerm_kubernetes_cluster_node_pool" "platform" {
#   count = var.create_node_pool ? 1 : 0

#   name                  = var.node_pool_taint
#   kubernetes_cluster_id = var.k8s_cluster_id
#   auto_scaling_enabled   = true
#   max_count             = var.node_pool_max_size
#   min_count             = var.node_pool_min_size
#   node_taints           = ["dedicated=${local.node_pool_taint}:NoSchedule"]
#   vm_size               = var.node_pool_node_size
#   vnet_subnet_id        = var.subnet_id
# }
