// Step 10 - Create Azure Kubernetes Cluster for Environment
// https://github.com/BankiFi/terraform-azure-aks
module "aks" {
  # source  = "app.terraform.io/BankiFi/aks/azure"
  # source  = "./module/aks"
  source  = "app.terraform.io/BankiFi/k8s/azure"
  version = "0.1.0"
  providers = {
    azurerm   = azurerm
    kubernetes = kubernetes.aks
    helm       = helm.aks
  }
  # version = "0.5.3"                ## regular version
  # version = "1.0.0"              ## client secret renewal ignored version 

  resource_name                    = local.resource_name
  kubernetes_version               = var.kubernetes_version
  k8s_common_labels                = local.k8s_common_labels
  name_prefix                      = var.name_prefix
  resource_group_name              = azurerm_resource_group.workspace.name
  location                         = var.primary_location #azurerm_resource_group.workspace.location
  env                              = var.env
  key_vault_id                     = module.keyvault_infra.key_vault_id
  vnet_name                        = module.network.vnet_name
  k8s_subnet_address_prefixes      = ["10.3.0.0/16"]
  firewall_name                    = module.network.firewall_name
  admin_group_id                   = azuread_group.admin_group.object_id
  k8s_additional_service_endpoints = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.EventHub"]

  // Demo, Test and Staging Environments
  default_node_min_count = 1
  default_node_max_count = 13
  default_node_size      = "Standard_D4s_v5"

  tags       = local.tags
# Cluster-level tags (all node pools will inherit)
  # -------------------------------
  # Dynamic node pools
  # -------------------------------
  node_pools = [
    {
      name         = "graphics"
      vm_size      = "Standard_D4s_v5" #"Standard_NC8as_T4_v3" #"Standard_D4s_v5" 
      node_count   = 1
      min_count    = 1
      max_count    = 3
      disk_size_gb = 128
      type         = "Standard"
      tags         = { "environment" = "dev", "owner" = "teamA" }
      labels       = { "role" = "app", "tier" = "frontend" }
    },
    {
      name         = "spotnp"
      vm_size      = "Standard_D4s_v5"
      node_count   = 1
      min_count    = 1
      max_count    = 25
      disk_size_gb = 128
      type         = "Spot"
      tags         = { "environment" = "dev", "owner" = "teamB" }
      labels       = { "role" = "batch", "tier" = "worker" }
    },
    # Add more node pools here dynamically
    {
      name         = "sbox"
      vm_size      = "Standard_D4s_v5"
      node_count   = 1
      min_count    = 0
      max_count    = 15
      disk_size_gb = 256
      type         = "Standard"
      tags         = { "environment" = "prod", "owner" = "analytics" }
      labels       = { "role" = "analytics", "tier" = "backend" }
    }
  ]

  firewall_private_ip_address = module.network.firewall_private_ip_address

  // Used to Configured Site to Site VPN
  //   k8s_additional_routes = [{
  //    name                         = "vendor"
  //    address_prefix               = "10.93.208.224/28"
  //    next_hop_type                = "VirtualAppliance"
  //    next_hop_in_ip_address       = "172.19.1.4"
  //    }]

  // k8s_additional_routes = [{
  //   name                    = "coop"
  //   address_prefix          = "10.93.208.224/28"
  //   next_hop_type           = "VirtualAppliance"
  //   next_hop_in_ip_address  = "172.19.1.4"
  // }]
    # depends_on = [azurerm_resource_group.workspace]
}

// Step 10 - Create Role Assignment for ACR in Central
resource "azurerm_role_assignment" "central_acr_access" {
  principal_id         = module.aks.object_id
  scope                = local.central_registry_id
  role_definition_name = "AcrPull"
}

# data "azurerm_web_application_firewall_policy" "web_application_firewall_policy" {
#   name                = "ScenarioOne"
#   resource_group_name = "baseline-sbox-uksouth" #azurerm_resource_group.workspace.name #"baseline-sbox-uksouth"
# }



