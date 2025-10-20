# // Step 07 - Deploy Base and Azure Role Assignments, Definitions and Bindings and Disable All Others
# // https://github.com/BankiFi/terraform-azure-keyvault
module "keyvault_platform" {
  for_each = var.subenvironments
  source   = "app.terraform.io/BankiFi/keyvault/azure"
  version  = "1.0.0"

  vault_name              = "${each.key}-${var.env}"
  # vault_name              = "${each.key}-${var.env}-platform"
  partner_name            = var.partner_name
  name_prefix             = var.name_prefix
  resource_group_name     = azurerm_resource_group.workspace.name
  env                     = var.env
  admin_group_id          = azuread_group.admin_group.object_id
  create_platform_secrets = true

  tags       = local.tags
  depends_on = [azurerm_resource_group.workspace]
}

# // Step 10 - Deploy AKS Cluster,  Kubernetes Role Assignments Definitions and Bindings
# resource "azurerm_key_vault_access_policy" "aks_keyvault_read" {
#   for_each = var.subenvironments

#   key_vault_id = module.keyvault_platform[each.key].key_vault_id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = module.aks.object_id

#   secret_permissions = [
#     "Get",
#     "List",
#   ]

#   key_permissions = [
#     "Get",
#     "List",
#   ]
# }

# # // Step 07 - Deploy Base and Azure Role Assignments, Definitions and Bindings and Disable All Others
resource "azurerm_key_vault_access_policy" "devteam" {
  for_each = var.subenvironments

  key_vault_id = module.keyvault_platform[each.key].key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azuread_group.developers_group.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]

  key_permissions = [
    "Get",
    "List",
  ]
}

# // Step 13 - Deploy BankiFi Platform
# // https://github.com/BankiFi/terraform-azure-bankifiplatform

# module "bankifi_platform" {
#   for_each = var.subenvironments

#   source = "app.terraform.io/BankiFi/bankifiplatform/azure"
#   version = "1.0.1"

#   deployment           = each.value.platform_deployment
#   resource_group_name  = azurerm_resource_group.workspace.name
#   storage_account_name = azurerm_storage_account.general.name

#   name_prefix     = var.name_prefix
#   partner_name    = var.partner_name
#   env             = var.env
#   tenant_id       = data.azurerm_client_config.current.tenant_id
#   subscription_id = data.azurerm_client_config.current.subscription_id

#   mongodb_version        = each.value.atlas_version
#   mongodbatlas_org_id    = var.mongodbatlas_org_id
#   mongodbatlas_adminteam = var.mongodbatlas_adminteam
#   mongodbatlas_devteam   = var.mongodbatlas_devteam
#   role_names             = ["GROUP_DATA_ACCESS_READ_ONLY", "GROUP_DATA_ACCESS_READ_WRITE"]

#   atlas_cidr_block = each.value.atlas_cidr_block

#   k8s_cluster_id = module.aks.cluster_id
#   subnet_id      = module.aks.vnet_subnet_id
#   key_vault_name = module.keyvault_platform[each.key].key_vault_name
#   key_vault_id   = module.keyvault_platform[each.key].key_vault_id
#   firewall_name  = module.network.firewall_name
#   vnet_name      = module.network.vnet_name

#   namespace_name                       = each.value.namespace_name
#   network_rule_collection_priority     = each.value.network_rule_collection_priority
#   application_rule_collection_priority = each.value.application_rule_collection_priority
#   node_pool_taint                      = each.value.node_pool_taint
#   workspace_prefix                     = each.key
#   workspace_env                        = var.env

#   // MongoDB node instance configuration
#   max_instance_size = each.value.max_instance_size
#   min_instance_size = each.value.min_instance_size

#   //This flag controls the node pool creation by the bankifi module
#   create_node_pool = each.value.create_node_pool

#   //This flag controls the creation of the jwt_shared_key and bankifi_signature manifests
#   create_manifests = each.value.create_manifests

#   //Platform node pool configuration
#   node_pool_min_size  = each.value.node_pool_min_size
#   node_pool_max_size  = each.value.node_pool_max_size
#   node_pool_node_size = "Standard_D8s_v3"

#   mongodb_databases = [
#     "consents",
#     "custodians",
#     "keystore",
#     "tokens",
#     "user_management",
#     "org_conf",
#     "rtp4",
#     "ledgers",
#     "reconciliation",
#     "internal",
#     "requesttopay",
#     "moneyhub-validation",
#     "notifications",
#     "user_settings",
#     "external-erps",
#     "billing",
#     "paymark",
#     "pay360",
#     "cash_flow_forecasting",
#     "mx",
#     "maverick",
#     "authorisation",
#     "bank-management",
#     "analytics",
#     "square",
#     "wcf",
#     "outbound-payments",
#     "taxes",
#     "observation",
#     "bulkpayments",
#     "response",
#     "rtbf"
#   ]

#   k8s_common_labels = local.k8s_common_labels
#   tags              = local.tags

#   depends_on = [azurerm_storage_account.general]
# }


# # // Step 14 - Deploy Monitoring
# # // https://github.com/BankiFi/terraform-prometheus-bankifiplatform

# # module "bankifi_monitoring" {
# #   source  = "app.terraform.io/BankiFi/bankifiplatform/prometheus"
# #   version = "1.0.0"

# #   env = var.env

# #   k8s_namespace      = module.prometheus.k8s_namespace
# #   monitor_namespaces = [for s in var.subenvironments : s.namespace_name]

# #   servicemonitor_enabled = true
# #   metrics_enabled        = true
# #   alerts_enabled         = false

# #   app_name     = module.prometheus.app_name
# #   release_name = module.prometheus.release_name

# #   k8s_common_labels = local.k8s_common_labels
# #   tags              = local.tags
# # }