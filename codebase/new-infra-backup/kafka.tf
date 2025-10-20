# module "platform_kafka" {
#   count = local.deployment_settings_map[var.deployment].kafka_enabled ? 1 : 0

#   # source  = "app.terraform.io/BankiFi/kafka/azure"
#   # version = "1.1.0"
#   source  = "app.terraform.io/BankiFi/kafka-eventhub/azure"
#   version = "0.1.0"

#   name                = "${var.workspace_prefix}-${var.workspace_env}"
#   name_prefix         = var.name_prefix
#   resource_group_name = data.azurerm_resource_group.bankifi.name
#   env                 = var.env
#   tags                = local.tags

#   # allow_subnet_id = var.subnet_id
# //  zone_redundant  = local.deployment_settings_map[var.deployment].kafka_zone_redundant
#   capacity        = local.deployment_settings_map[var.deployment].kafka_capacity
# }

# resource "kubernetes_secret" "kafka_connection" {
#   count = local.deployment_settings_map[var.deployment].kafka_enabled ? 1 : 0

#   metadata {
#     name      = "kafka-connection"
#     namespace = kubernetes_namespace.bankifi.id
#     # labels    = local.k8s_common_labels
#   }

#   data = {
#     host = module.platform_kafka[0].connection_string
#   }

#   lifecycle {
#     ignore_changes = all
#   }
# }

# resource "azurerm_key_vault_secret" "kafka_connection" {
#   count = local.deployment_settings_map[var.deployment].kafka_enabled ? 1 : 0

#   name         = "kafka-connection-string"
#   value        = module.platform_kafka[0].connection_string
#   key_vault_id = var.key_vault_id

#   tags = local.tags

#   lifecycle {
#     ignore_changes = all
#   }
# }


# module "platform_kafka" {
#   count = local.deployment_settings_map[var.deployment].kafka_enabled ? 1 : 0
#   source = "./module/kafka" 
# #   source  = "app.terraform.io/BankiFi/kafka/azure"
# #   version = "1.1.0"

#   name                = "${var.workspace_prefix}-${var.workspace_env}"
#   name_prefix         = var.name_prefix
#   resource_group_name = data.azurerm_resource_group.bankifi.name
#   env                 = var.env
#   tags                = local.tags

#   allow_subnet_id = var.subnet_id
# # //  zone_redundant  = local.deployment_settings_map[var.deployment].kafka_zone_redundant
#   capacity        = local.deployment_settings_map[var.deployment].kafka_capacity
# }

# resource "kubernetes_secret" "kafka_connection" {
#   count = local.deployment_settings_map[var.deployment].kafka_enabled ? 1 : 0

#   metadata {
#     name      = "kafka-connection"
#     namespace = kubernetes_namespace.bankifi.id
#     labels    = local.k8s_common_labels
#   }

#   data = {
#     host = module.platform_kafka[0].connection_string
#   }

#   lifecycle {
#     ignore_changes = all
#   }
# }

# resource "azurerm_key_vault_secret" "kafka_connection" {
#   count = local.deployment_settings_map[var.deployment].kafka_enabled ? 1 : 0

#   name         = "kafka-connection-string"
#   value        = module.platform_kafka[0].connection_string
#   key_vault_id = var.key_vault_id

#   tags = local.tags

#   lifecycle {
#     ignore_changes = all
#   }
# }


# # ####main.tf

# locals {
#   k8s_cluster_id    = var.k8s_cluster_id
# # #   k8s_common_labels = var.k8s_common_labels
# # #   tags              = var.tags

#   deployment_settings_map = {
#     "Basic" = {
#       kafka_enabled        = true
#       kafka_capacity       = 1
#       kafka_zone_redundant = false

#       cdn_enabled = false

#       mongodb_num_shards         = 1
#       mongodb_replication_factor = 3
#       mongodb_instance_type      = "M10"
#       mongodb_backup_enabled     = false
#     },
#     "Coop" = {
#       kafka_enabled        = false
#       kafka_capacity       = 1
#       kafka_zone_redundant = false

#       cdn_enabled = false

#       mongodb_num_shards         = 1
#       mongodb_replication_factor = 3
#       mongodb_instance_type      = "M10"
#       mongodb_backup_enabled     = false
#     },
#     "Standard" = {
#       kafka_enabled        = true
#       kafka_capacity       = 2
#       kafka_zone_redundant = var.zone_redundant
      
#       cdn_enabled = true

#       mongodb_num_shards         = 1
#       mongodb_replication_factor = 3
#       mongodb_instance_type      = "M40"
#       mongodb_backup_enabled     = true
#     }
#   }
# }
# #   cdn_enabled = var.storage_account_name != null && local.deployment_settings_map[var.deployment].cdn_enabled

# #   // Node pool taint for a multi node pool environment type
# #   node_pool_taint = var.node_pool_taint
# # }

# # data "azurerm_resource_group" "bankifi" {
# #   name = var.resource_group_name
# # }

# # resource "kubernetes_namespace" "bankifi" {
# #   metadata {
# #     labels = merge(local.k8s_common_labels, {
# #       "azure-key-vault-env-injection" = "enabled"
# #     })
# #     name = var.namespace_name
# #   }
# # }

# # data "azurerm_storage_account" "general" {
# #   count = local.cdn_enabled ? 1 : 0

# #   name                = var.storage_account_name
# #   resource_group_name = var.resource_group_name
# # }

# # resource "azurerm_kubernetes_cluster_node_pool" "platform" {
# #   count = var.create_node_pool ? 1 : 0

# #   name                  = var.node_pool_taint
# #   kubernetes_cluster_id = var.k8s_cluster_id
# #   auto_scaling_enabled   = true
# #   max_count             = var.node_pool_max_size
# #   min_count             = var.node_pool_min_size
# #   node_taints           = ["dedicated=${local.node_pool_taint}:NoSchedule"]
# #   vm_size               = var.node_pool_node_size
# #   vnet_subnet_id        = var.subnet_id
# # }


# # #output.tf
# # output "k8s_namespace" {
# #   description = "Kubernetes namespace name"
# #   value       = kubernetes_namespace.bankifi.id
# # }

# # output "dev_group_id" {
# #   description = "Azure AD Group Id for Developers"
# #   value       = azuread_group.bankifi_dev_group.object_id
# # }

# # output "node_pool_taint" {
# #   value = local.node_pool_taint
# # }

# # output "mongodb_project_id" {
# #   description = "MongoDB Project ID"
# #   value       = mongodbatlas_project.platform.id
# # }
# # ###rbac.tf

# # resource "azuread_group" "bankifi_dev_group" {
# #   display_name     = "${title(var.namespace_name)} ${var.resource_name} Platform Devs"
# #   security_enabled = true
# # }

# # resource "kubernetes_role_binding" "bankifi_dev_ns_role_binding" {
# #   metadata {
# #     labels    = local.k8s_common_labels
# #     name      = "${var.namespace_name}-${var.resource_name}-devs"
# #     namespace = kubernetes_namespace.bankifi.id
# #   }

# #   role_ref {
# #     api_group = "rbac.authorization.k8s.io"
# #     kind      = "Role"
# #     name      = "view"
# #   }

# #   subject {
# #     kind = "Group"
# #     name = azuread_group.bankifi_dev_group.object_id
# #   }
# # }

# # resource "azurerm_role_assignment" "k8s_dev_assignment" {
# #   principal_id         = azuread_group.bankifi_dev_group.object_id
# #   scope                = local.k8s_cluster_id
# #   role_definition_name = "Azure Kubernetes Service Cluster User Role"
# # }

# # // Mongo DB Administrator

# # resource "random_password" "mongodb_admin_password" {
# #   length           = 16
# #   override_special = "_#.$,"
# # }

# # resource "mongodbatlas_database_user" "admin" {
# #   username   = "${mongodbatlas_project.platform.name}-admin"
# #   password   = random_password.mongodb_admin_password.result
# #   project_id = mongodbatlas_project.platform.id

# #   auth_database_name = "admin"

# #   roles {
# #     role_name     = "readWrite"
# #     database_name = "admin"
# #   }

# #   roles {
# #     role_name     = "dbAdminAnyDatabase"
# #     database_name = "admin"
# #   }

# #   roles {
# #     role_name     = "readWriteAnyDatabase"
# #     database_name = "admin"
# #   }

# #   roles {
# #     role_name     = "clusterMonitor"
# #     database_name = "admin"
# #   }
# # }

# # resource "azurerm_key_vault_secret" "mongodb_admin_password" {
# #   name         = "mongodb-admin-password"
# #   value        = random_password.mongodb_admin_password.result
# #   key_vault_id = var.key_vault_id

# #   tags = local.tags
# # }

# # // Mongo DB Operator

# # locals {
# #   mongodb_cluster_address = substr(
# #     mongodbatlas_cluster.cluster.connection_strings[0].private_srv,
# #     length("mongodb+srv://"),
# #     length(mongodbatlas_cluster.cluster.connection_strings[0].private_srv)
# #   )
# #   mongodb_operator_creds = "${mongodbatlas_database_user.operator.username}:${urlencode(mongodbatlas_database_user.operator.password)}"
# #   mongodb_operator_url   = "mongodb+srv://${local.mongodb_operator_creds}@${local.mongodb_cluster_address}/test"
# # }

# # resource "random_password" "mongodb_operator_password" {
# #   length           = 16
# #   override_special = "_%@"
# # }

# # resource "mongodbatlas_database_user" "operator" {
# #   username   = "${mongodbatlas_project.platform.name}-operator"
# #   password   = random_password.mongodb_operator_password.result
# #   project_id = mongodbatlas_project.platform.id

# #   auth_database_name = "admin"

# #   roles {
# #     role_name     = "readAnyDatabase"
# #     database_name = "admin"
# #   }
# # }

# # resource "azurerm_key_vault_secret" "mongodb_operator_password" {
# #   name         = "mongodb-operator-password"
# #   value        = random_password.mongodb_operator_password.result
# #   key_vault_id = var.key_vault_id

# #   tags = local.tags
# # }

# # resource "azurerm_key_vault_secret" "mongodb_operator_url" {
# #   name         = "mongodb-operator-url"
# #   value        = local.mongodb_operator_url
# #   key_vault_id = var.key_vault_id

# #   tags = local.tags
# # }


# # #####security.tf
# # // Platform super user
# # resource "random_password" "superuser_password" {
# #   length = 32
# # }

# # resource "azurerm_key_vault_secret" "superuser_password" {
# #   name         = "superuser-password"
# #   value        = random_password.superuser_password.result
# #   key_vault_id = var.key_vault_id

# #   tags = local.tags
# # }

# # // Generate Signature
# # resource "azurerm_key_vault_key" "bankifi_signature" {
# #   name         = "bankifi-signature"
# #   key_vault_id = var.key_vault_id
# #   key_type     = "RSA"
# #   key_size     = 2048

# #   key_opts = [
# #     "decrypt",
# #     "encrypt",
# #     "sign",
# #     "unwrapKey",
# #     "verify",
# #     "wrapKey",
# #   ]

# #   tags = local.tags
# # }

# # // Generate JWT signature key
# # resource "random_password" "jwt_shared_key" {
# #   length           = 32
# #   special          = true
# #   override_special = "_%@"
# # }

# # resource "azurerm_key_vault_secret" "jwt_shared_key" {
# #   name         = "jwt-shared-key"
# #   value        = random_password.jwt_shared_key.result
# #   key_vault_id = var.key_vault_id

# #   tags = local.tags
# # }

# # // Step 05: Disable All kubernetes-alpha in workspace/resources/modules with provider = kubernetes-alpha
# # // Step 13: Deploy BankiFi Platform

# # resource "kubernetes_manifest" "bankifi_signature" {
# #   count = var.create_manifests ? 1 : 0

# #   manifest = yamldecode(templatefile("${path.module}/files/akv2k8s/key.k8s.yaml", {
# #     name          = azurerm_key_vault_key.bankifi_signature.name
# #     namespace     = kubernetes_namespace.bankifi.id
# #     keyvault_name = var.key_vault_name
# #     data_key      = "key"
# #   }))

# #   // force field manager conflicts to be overridden
# #   # field_manager {
# #   #   force_conflicts = true
# #   # }

# #   depends_on = [azurerm_key_vault_key.bankifi_signature]
# # }


# # // Step 05: Disable All kubernetes-alpha in workspace/resources/modules with provider = kubernetes-alpha
# # // Step 13: Deploy BankiFi Platform

# # resource "kubernetes_manifest" "jwt_shared_key" {
# #   count = var.create_manifests ? 1 : 0

# #   manifest = yamldecode(templatefile("${path.module}/files/akv2k8s/single-secret.k8s.yaml", {
# #     name          = azurerm_key_vault_secret.jwt_shared_key.name
# #     namespace     = kubernetes_namespace.bankifi.id
# #     keyvault_name = var.key_vault_name
# #     data_key      = "key"
# #   }))

# #   // force field manager conflicts to be overridden
# #   # field_manager {
# #   #   force_conflicts = true
# #   # }

# #   depends_on = [azurerm_key_vault_secret.jwt_shared_key]
# # }

# # ##varible.tf

# # # variable "env" {}

# # variable "tags" {
# #   description = "Common resource tags"
# #   type        = map(string)
# #   default     = {}
# # }

# # variable "workspace_prefix" {
# #   type = string
# # }

# # variable "workspace_env" {
# #   type = string
# # }

# # # variable "partner_name" {
# # #   default = "Bankifi"
# # # }

# # # variable "name_prefix" {
# # #   description = "Name prefix to be used in the resources"
# # #   type        = string
# # # }

# # variable "resource_group_name" {
# #   description = "Resource group name"
# #   type        = string
# # }

# # variable "storage_account_name" {
# #   description = "Storage account name"
# #   type        = string
# #   default     = null
# # }

# # variable "tenant_id" {
# #   description = "Azure Tenant ID"
# #   type        = string
# # }

# variable "subscription_id" {
#   description = "Azure Subscription ID"
#   type        = string
# }

# variable "deployment" {
#   description = "Deployment mode for the platform deployment"
#   type        = string
#   default     = "Basic"
# }

# variable "k8s_cluster_id" {
#   description = "Identifier of the K8S resource for the cluster"
#   type        = string
# }

# # variable "k8s_common_labels" {
# #   description = "Common K8S labels for resources"
# #   type        = map(string)
# #   default     = {}
# # }

# # variable "vnet_name" {
# #   description = "Name of the Virtual Network where the platform is being deployed"
# #   type        = string
# # }

# # variable "subnet_id" {
# #   description = "Identifier of the subnet where the platform lives"
# #   type        = string
# # }

# # variable "firewall_name" {
# #   description = "Name of the Firewall for egress communications"
# #   type        = string
# # }

# variable "key_vault_id" {
#   description = "Identifier of the KeyVault for the platform"
#   type        = string
# }

# # variable "key_vault_name" {
# #   description = "Name of the KeyVault for the platform"
# #   type        = string
# # }

# # // MongoDB

# # # variable "mongodbatlas_org_id" {
# # #   description = "MongoDB Atlas Organisation ID"
# # #   type        = string
# # # }

# # variable "mongodb_version" {
# #   description = "MongoDB Version"
# #   type        = string
# #   default     = "6.0"
# # }

# # variable "mongodb_databases" {
# #   description = "Names of the MongoDB databases that need to be accessed"
# #   type        = list(string)
# #   default     = []
# # }

# # # variable "mongodbatlas_adminteam" {
# # #   description = "Team ID for Admin Access"
# # #   type        = string
# # # }

# # # variable "mongodbatlas_devteam" {
# # #   description = "Team ID for Developers Access"
# # #   type        = string
# # # }

# # variable "atlas_cidr_block" {
# #   description = "CIDR block for the Atlas peering connection"
# #   type        = string
# # }

# # variable "atlas_region" {
# #   description = "MongoDB Atlas Region"
# #   type        = string
# # }

# # variable "role_names" {
# #   description = "List of developer access roles to the mongodb project"
# #   type        = list(string)
# #   default     = ["GROUP_DATA_ACCESS_READ_ONLY"]
# # }

# # // Node pool parameters

# # variable "node_pool_min_size" {
# #   type        = number
# #   description = "Minimum number of VMs available in the dedicated pool"
# #   default     = 1
# # }

# # variable "node_pool_max_size" {
# #   type        = number
# #   description = "Maximum number of VMs available in the dedicated pool"
# #   default     = 2
# # }

# # variable "node_pool_node_size" {
# #   type        = string
# #   description = "Drone runner VM size"
# #   default     = "Standard_DS2_v2"
# # }

# # variable "namespace_name" {
# #   type        = string
# #   description = "K8S namespace subenvironment platform name"
# # }

# # variable "node_pool_taint" {
# #   type        = string
# #   description = "Node pool taint"
# # }

# # variable "create_node_pool" {
# #   description = "Whether this module should create its own node pool or not"
# #   type        = bool
# #   default     = true
# # }

# # variable "network_rule_collection_priority" {
# #   description = "Priority of the network rule collection"
# #   type        = number
# # }

# # variable "application_rule_collection_priority" {
# #   description = "Priority of the application rule collection"
# #   type        = number
# # }

# variable "resource_name" {
#   description = "Top level resource name"
#   type = string
# }

# variable "zone_redundant" {
#   description = "Whether the EventHubs should be created across availability zones"
#   type        = bool
# }

# # variable "min_instance_size" {
# #   description = "MongoDB Atlas minimum node size"
# #   type = string
# #   default = "M10"
# # }

# # variable "max_instance_size" {
# #   description = "MongoDB Atlas maximum node size"
# #   type = string
# #   default = "M40" 
# # }


# # // Kubernetes manifests workaround
# # variable "create_manifests" {
# #   description = "Workaround for creating manifests in a separate apply"
# #   type = bool 
# # }
