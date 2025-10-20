module "mongo" {
  for_each = var.subenvironments
  source  = "./module/mongo"
  providers = {
    kubernetes = kubernetes.aks
  }
#   source  = "app.terraform.io/BankiFi/mongo/mongodbatlas"
#   version = "0.1.1"

  deployment           = each.value.platform_deployment
#   resource_group_name  = azurerm_resource_group.workspace.name
#   storage_account_name = azurerm_storage_account.general.name

###rewuired vars by vivek

  resource_name       = "${var.name_prefix}-${each.key}-mongo"
  resource_group_name = azurerm_resource_group.workspace.name
  key_vault_id        = module.keyvault_platform[each.key].key_vault_id

###############

  name_prefix     = var.name_prefix
  partner_name    = var.partner_name
#   env = var.env == "baseline-uk-west" ? "prod" : var.env
  env = contains(["baseline", "baseline-uk-west"], var.env) ? "prod" : var.env
#   env             = "baseline-uk-west"
#   env             = var.env
  tenant_id       = data.azurerm_client_config.current.tenant_id
  subscription_id = data.azurerm_client_config.current.subscription_id

  mongodb_version        = each.value.atlas_version
  mongodbatlas_org_id    = var.mongodbatlas_org_id
  mongodbatlas_adminteam = var.mongodbatlas_adminteam
  mongodbatlas_devteam   = var.mongodbatlas_devteam
  role_names             = ["GROUP_DATA_ACCESS_READ_ONLY", "GROUP_DATA_ACCESS_READ_WRITE"]

  atlas_cidr_block = each.value.atlas_cidr_block

#   k8s_cluster_id = module.aks.cluster_id
#   subnet_id      = module.aks.vnet_subnet_id
#   key_vault_name = module.keyvault_platform[each.key].key_vault_name
#   key_vault_id   = module.keyvault_platform[each.key].key_vault_id
  firewall_name  = module.network.firewall_name
  vnet_name      = module.network.vnet_name

#   namespace_name                       = each.value.namespace_name
  namespace_name = each.key
  network_rule_collection_priority     = each.value.network_rule_collection_priority
  application_rule_collection_priority = each.value.application_rule_collection_priority
#   node_pool_taint                      = each.value.node_pool_taint
  workspace_prefix                     = each.key
  workspace_env                        = var.env

  // MongoDB node instance configuration
  max_instance_size = each.value.max_instance_size
  min_instance_size = each.value.min_instance_size

  //This flag controls the node pool creation by the bankifi module
#   create_node_pool = each.value.create_node_pool

#   //This flag controls the creation of the jwt_shared_key and bankifi_signature manifests
#   create_manifests = each.value.create_manifests


  mongodb_databases = [
    "test-uk-west",
    "test-uk-west2",
    "consents"
    # "custodians",
    # "keystore",
    # "tokens",
    # "user_management",
    # "org_conf",
    # "rtp4",
    # "ledgers",
    # "reconciliation",
    # "internal",
    # "requesttopay",
    # "moneyhub-validation",
    # "notifications",
    # "user_settings",
    # "external-erps",
    # "billing",
    # "paymark",
    # "pay360",
    # "cash_flow_forecasting",
    # "mx",
    # "maverick",
    # "authorisation",
    # "bank-management",
    # "analytics",
    # "square",
    # "wcf",
    # "outbound-payments",
    # "taxes",
    # "observation",
    # "bulkpayments",
    # "response",
    # "rtbf"
  ]

  k8s_common_labels = local.k8s_common_labels
  tags              = local.tags

  depends_on = [azurerm_storage_account.general,kubernetes_namespace.bankifi]
}
