module "platform_kafka" {
  count = local.deployment_settings_map[var.deployment].kafka_enabled ? 1 : 0

  source  = "app.terraform.io/BankiFi/kafka-eventhub/azure"
  version = "0.1.0"

  # Required variables
  env                  = var.env
  name                = "${var.workspace_prefix}-${var.workspace_env}"
#   name                 = "${var.name_prefix}-platform"
  name_prefix          = var.name_prefix
  resource_group_name =  azurerm_resource_group.workspace.name
#   resource_group_name  = var.resource_group_name
  capacity             = var.capacity
  auto_inflate         = var.auto_inflate
  zone_redundant       = var.zone_redundant
  allow_subnet_id      = module.aks.vnet_subnet_id #var.subnet_id
  tags                 = local.tags
#   k8s_cluster_id       = module.aks.cluster_id
}

# Output Kafka connection string from module
output "platform_kafka_connection_string" {
  value     = local.deployment_settings_map[var.deployment].kafka_enabled && length(module.platform_kafka) > 0 ? module.platform_kafka[0].connection_string : null
  sensitive = true
}



locals {
#   k8s_cluster_id    = var.k8s_cluster_id
# #   k8s_common_labels = var.k8s_common_labels
# #   tags              = var.tags

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
}
# variable "k8s_cluster_id" {
#   description = "Identifier of the K8S resource for the cluster"
#   type        = string
# }

variable "zone_redundant" {
  description = "Whether the EventHubs should be created across availability zones"
  type        = bool
  default = true 
}
variable "deployment" {
  description = "Deployment mode for the platform deployment"
  type        = string
  default     = "Basic"
}
# variable "resource_group_name" {
#   description = "Name of the resource group for Kafka"
#   type        = string
# }

variable "capacity" {
  description = "Capacity for the EventHub namespace"
  type        = number
  default     = 1
}

variable "auto_inflate" {
  description = "Enable auto-inflate on EventHub"
  type        = bool
  default     = false
}

# variable "allow_subnet_id" {
#   description = "Subnet ID allowed to connect to EventHub namespace"
#   type        = string
# }

variable "workspace_prefix" {
  type    = string
  default = "bankifi"
}

variable "workspace_env" {
  type    = string
  default = "baseline-west"
}
###namespace creation

resource "kubernetes_namespace" "bankifi" {
  for_each = var.subenvironments

  metadata {
    name = each.key  # or each.value depending on what you want
    labels = merge(
      local.k8s_common_labels,
      {
        "azure-key-vault-env-injection" = "enabled"
      }
    )
  }
  provider = kubernetes.aks
  depends_on = [module.aks] 
}

# resource "kubernetes_namespace" "bankifi" {
#   metadata {
#     labels = merge(local.k8s_common_labels, {
#       "azure-key-vault-env-injection" = "enabled"
#     })
#     name = var.subenvironments #namespace_name
#   }
# }