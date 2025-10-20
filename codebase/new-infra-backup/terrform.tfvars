# # tfvars

# user_node_size           = "Standard_D4s_v5"
# user_node_disk_size_gb   = 128
# user_node_min_count      = 1
# user_node_max_count      = 3
# user_node_count          = 1

# # --------------------------
# # Spot Node Pool
# # --------------------------
# spot_node_size           = "Standard_D4s_v5"
# spot_node_disk_size_gb   = 128
# spot_node_min_count      = 0
# spot_node_max_count      = 5
# spot_node_count          = 1

###Mongo

deployment           = each.value.platform_deployment
resource_group_name  = azurerm_resource_group.workspace.name
storage_account_name = azurerm_storage_account.general.name

name_prefix     = var.name_prefix
partner_name    = var.partner_name
env             = var.env
tenant_id       = data.azurerm_client_config.current.tenant_id
subscription_id = data.azurerm_client_config.current.subscription_id

mongodb_version        = each.value.atlas_version
mongodbatlas_org_id    = var.mongodbatlas_org_id
mongodbatlas_adminteam = var.mongodbatlas_adminteam
mongodbatlas_devteam   = var.mongodbatlas_devteam
role_names             = ["GROUP_DATA_ACCESS_READ_ONLY", "GROUP_DATA_ACCESS_READ_WRITE"]

atlas_cidr_block = each.value.atlas_cidr_block

k8s_cluster_id = module.aks.cluster_id
subnet_id      = module.aks.vnet_subnet_id
key_vault_name = module.keyvault_platform[each.key].key_vault_name
key_vault_id   = module.keyvault_platform[each.key].key_vault_id
firewall_name  = module.network.firewall_name
vnet_name      = module.network.vnet_name

namespace_name                       = each.value.namespace_name
network_rule_collection_priority     = each.value.network_rule_collection_priority
application_rule_collection_priority = each.value.application_rule_collection_priority
node_pool_taint                      = each.value.node_pool_taint
workspace_prefix                     = each.key
workspace_env                        = var.env

// MongoDB node instance configuration
max_instance_size = each.value.max_instance_size
min_instance_size = each.value.min_instance_size

//This flag controls the node pool creation by the bankifi module
create_node_pool = each.value.create_node_pool

//This flag controls the creation of the jwt_shared_key and bankifi_signature manifests
create_manifests = each.value.create_manifests

//Platform node pool configuration
node_pool_min_size  = each.value.node_pool_min_size
node_pool_max_size  = each.value.node_pool_max_size
node_pool_node_size = "Standard_D8s_v3"

mongodb_databases = [
"consents",
"custodians",
"keystore",
"tokens",
"user_management",
"org_conf",
"rtp4",
"ledgers",
"reconciliation",
"internal",
"requesttopay",
"moneyhub-validation",
"notifications",
"user_settings",
"external-erps",
"billing",
"paymark",
"pay360",
"cash_flow_forecasting",
"mx",
"maverick",
"authorisation",
"bank-management",
"analytics",
"square",
"wcf",
"outbound-payments",
"taxes",
"observation",
"bulkpayments",
"response",
"rtbf"
]

k8s_common_labels = local.k8s_common_labels
tags              = local.tags

depends_on = [azurerm_storage_account.general]
