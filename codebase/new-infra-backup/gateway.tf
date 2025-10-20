// Step 11 - Application Gateway to Ingress Controller
# // https://github.com/BankiFi/terraform-azure-gateway

// https://github.com/BankiFi/terraform-azure-gateway
module "gateway" {
  # source  = "app.terraform.io/BankiFi/gateway/azure"
  # version = "1.0.6" 
  source  = "app.terraform.io/BankiFi/ag/azure"
  version = "0.1.0"
  providers = {
    azurerm   = azurerm   # map to your default azurerm provider
    azurerm.dns     = azurerm.dns
    azurerm.default = azurerm.default
    kubernetes = kubernetes.aks
    helm       = helm.aks
  }
#   providers = {
#     kubernetes = kubernetes.aks
#     helm       = helm.aks
#     }
#   providers = {
#     azurerm.dns     = azurerm
#     azurerm.default = azurerm
#     kubernetes      = kubernetes.aks
#     helm            = helm.aks
#   }

  resource_name       = local.resource_name
  partner_name        = var.partner_name
  name_prefix         = var.name_prefix
  dns_resource_group  = var.dns_resource_group
  resource_group_name = azurerm_resource_group.workspace.name
  env                 = var.env
  gateway_location    = azurerm_resource_group.workspace.location #"ukwest"#
  # gateway_location = "uksouth"


  k8s_principal_id  = module.aks.object_id
  k8s_common_labels = local.k8s_common_labels

  vnet_name        = module.network.vnet_name
  key_vault_id     = module.keyvault_infra.key_vault_id
  subnet_id        = module.network.ingress_subnet_id
  public_ip_name   = module.network.ingress_public_ip_name
  dns_zone_name    = data.azurerm_dns_zone.env_dns_zone.name
  dns_subscription = data.azurerm_subscription.current.subscription_id

  firewall_policy_id = module.gateway.waf_policy_id #data.azurerm_web_application_firewall_policy.web_application_firewall_policy.id

  ingress_version      = "1.5.0"
  cert_manager_version = "1.16.2"

  min_instances = 1
  max_instances = 2

  cert_email = var.partner_email
  cluster_issuer_solver = "none"  ##added for issuer error
  

  tags       = local.tags
  depends_on = [module.aks] #[module.aks]
}
