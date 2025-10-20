# // Step 10 - Create Azure Kubernetes Cluster for Environment
# // https://github.com/BankiFi/terraform-azure-aks
# module "aks" {
#   # source  = "app.terraform.io/BankiFi/aks/azure"
#   source  = "./module/aks"
#   # version = "0.5.3"                ## regular version
#   # version = "1.0.0"              ## client secret renewal ignored version 

#   resource_name                    = local.resource_name
#   kubernetes_version               = var.kubernetes_version
#   k8s_common_labels                = local.k8s_common_labels
#   name_prefix                      = var.name_prefix
#   resource_group_name              = azurerm_resource_group.workspace.name
#   location                         = azurerm_resource_group.workspace.location
#   env                              = var.env
#   key_vault_id                     = module.keyvault_infra.key_vault_id
#   vnet_name                        = module.network.vnet_name
#   k8s_subnet_address_prefixes      = ["10.3.0.0/16"]
#   firewall_name                    = module.network.firewall_name
#   admin_group_id                   = azuread_group.admin_group.object_id
#   k8s_additional_service_endpoints = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.EventHub"]

#   // Demo, Test and Staging Environments
#   default_node_min_count = 12
#   default_node_max_count = 13
#   default_node_size      = "Standard_D8s_v3"

#   tags       = local.tags
#   user_node_size           = "Standard_D4s_v5"
#   user_node_disk_size_gb   = 128
#   user_node_min_count      = 1
#   user_node_max_count      = 3
#   user_node_count          = 1

#   # --------------------------
#   # Spot Node Pool
#   # --------------------------
#   spot_node_size           = "Standard_D4s_v5"
#   spot_node_disk_size_gb   = 128
#   spot_node_min_count      = 0
#   spot_node_max_count      = 5
#   spot_node_count          = 1
#   # depends_on = [azurerm_resource_group.workspace]

#   // Production Environments
#   // default_node_min_count         = 4
#   // default_node_max_count         = 8
#   // default_node_size              = "Standard_D4s_v3"

#   firewall_private_ip_address = module.network.firewall_private_ip_address

#   // Used to Configured Site to Site VPN
#   //   k8s_additional_routes = [{
#   //    name                         = "vendor"
#   //    address_prefix               = "10.93.208.224/28"
#   //    next_hop_type                = "VirtualAppliance"
#   //    next_hop_in_ip_address       = "172.19.1.4"
#   //    }]

#   // k8s_additional_routes = [{
#   //   name                    = "coop"
#   //   address_prefix          = "10.93.208.224/28"
#   //   next_hop_type           = "VirtualAppliance"
#   //   next_hop_in_ip_address  = "172.19.1.4"
#   // }]

# }

# // Step 10 - Create Role Assignment for ACR in Central
# resource "azurerm_role_assignment" "central_acr_access" {
#   principal_id         = module.aks.object_id
#   scope                = local.central_registry_id
#   role_definition_name = "AcrPull"
# }

# data "azurerm_web_application_firewall_policy" "web_application_firewall_policy" {
#   name                = "ScenarioOne"
#   resource_group_name = "baseline-sbox-uksouth"
# }

# // Step 11 - Application Gateway to Ingress Controller
# // https://github.com/BankiFi/terraform-azure-gateway
# module "gateway" {
#   source  = "app.terraform.io/BankiFi/gateway/azure"
#   version = "1.0.6"

#   providers = {
#     azurerm.dns     = azurerm
#     azurerm.default = azurerm
#   }

#   resource_name       = local.resource_name
#   partner_name        = var.partner_name
#   name_prefix         = var.name_prefix
#   dns_resource_group  = var.dns_resource_group
#   resource_group_name = azurerm_resource_group.workspace.name
#   env                 = var.env
#   gateway_location    = azurerm_resource_group.workspace.location

#   k8s_principal_id  = module.aks.object_id
#   k8s_common_labels = local.k8s_common_labels

#   vnet_name        = module.network.vnet_name
#   key_vault_id     = module.keyvault_infra.key_vault_id
#   subnet_id        = module.network.ingress_subnet_id
#   public_ip_name   = module.network.ingress_public_ip_name
#   dns_zone_name    = data.azurerm_dns_zone.env_dns_zone.name
#   dns_subscription = data.azurerm_subscription.current.subscription_id

#   firewall_policy_id = data.azurerm_web_application_firewall_policy.web_application_firewall_policy.id

#   ingress_version = "1.5.0"
#   cert_manager_version = "1.16.2"

#   min_instances = 1
#   max_instances = 2

#   # cluster_issuer_solver = "none"

#   cert_email = var.partner_email

#   tags       = local.tags
#   depends_on = [data.azurerm_dns_zone.env_dns_zone]
# }

# # // Step 12 - Azure Key Vault to Kubernetes Secret Bridge
# # //https://github.com/BankiFi/terraform-k8s-akv2k8s
# # module "akv2k8s" {
# #   source  = "app.terraform.io/BankiFi/akv2k8s/k8s"
# #   version = "1.0.0"

# #   k8s_common_labels = local.k8s_common_labels
# # }