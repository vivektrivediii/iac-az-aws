# // https://github.com/BankiFi/terraform-azure-network
module "network" {
  source                   = "app.terraform.io/BankiFi/network/azure"
  version                  = "1.0.0"
  name_prefix              = var.name_prefix
  resource_group_name      = azurerm_resource_group.workspace.name
  env                      = var.env
  vnet_address_space       = ["10.0.0.0/8"]
  ingress_address_prefixes = ["10.0.0.0/24"]
  egress_address_prefixes  = ["10.0.1.0/24"]

  tags       = local.tags
  depends_on = [azurerm_resource_group.workspace]
}

# // https://github.com/BankiFi/terraform-azure-keyvault
module "keyvault_infra" {
  source  = "app.terraform.io/BankiFi/keyvault/azure"
  version = "1.0.0"

  vault_name              = "${var.partner_name}-${var.env}-infra"
  partner_name            = var.partner_name
  name_prefix             = var.name_prefix
  resource_group_name     = azurerm_resource_group.workspace.name
  env                     = var.env
  admin_group_id          = azuread_group.admin_group.object_id
  create_platform_secrets = false

  tags       = local.tags
  depends_on = [azurerm_resource_group.workspace]
}