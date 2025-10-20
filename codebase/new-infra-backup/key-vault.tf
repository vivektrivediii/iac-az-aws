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

# AKS Key Vault Access Policy
resource "azurerm_key_vault_access_policy" "aks_keyvault_read" {
  for_each = var.subenvironments

  key_vault_id = module.keyvault_platform[each.key].key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.aks.object_id
#   lifecycle {
#     ignore_changes = [value]
#   }
  lifecycle {
    prevent_destroy = false
    # ignore_changes = all
  }

  secret_permissions = [
    "Get",
    "List",
    "Delete",
    "Set",
  ]

  key_permissions = [
    "Get",
    "List",
    "Delete",
    
  ]
  depends_on = [module.keyvault_platform]
}

# Dev Team Key Vault Access Policy
resource "azurerm_key_vault_access_policy" "devteam" {
  for_each = var.subenvironments

  key_vault_id = module.keyvault_platform[each.key].key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azuread_group.developers_group.object_id
#   lifecycle {
#     ignore_changes = [value]
#   }
  lifecycle {
    prevent_destroy = false
    # ignore_changes = all
  }

  secret_permissions = [
    "Get",
    "List",
    "Delete",
    "Set",
  ]

  key_permissions = [
    "Get",
    "List",
    "Delete",
    
  ]
}

# Terraform Service Principal Key Vault Access Policy
resource "azurerm_key_vault_access_policy" "terraform_sp" {
  for_each     = var.subenvironments
  key_vault_id = module.keyvault_platform[each.key].key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  # Look up Terraform SPN
  object_id = data.azuread_service_principal.terraform_sp.object_id
  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Purge"
  ]
  # secret_permissions = [
  #   "Get",
  #   "List",
  #   "Set",
  #   "Delete",
  # ]

  key_permissions = [
    "Get",
    "List",
    "Delete",
  ]
  lifecycle {
    prevent_destroy = false
    ignore_changes  = all  # <-- prevents Terraform from removing this before secret deletion
  }
}

# Lookup for Terraform service principal
data "azuread_service_principal" "terraform_sp" {
  client_id = "8d999df7-fa9c-45f6-906f-0b5931e6729e" # from your error log
}
# resource "azurerm_role_assignment" "terraform_kv_secret_user" {
#   scope                = azurerm_key_vault.example.id
#   role_definition_name = "Key Vault Secrets Officer"
#   principal_id         = data.azuread_service_principal.terraform_sp.object_id
# }
resource "azurerm_role_assignment" "terraform_kv_secret_user" {
  for_each             = var.subenvironments
  scope                = module.keyvault_platform[each.key].key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azuread_service_principal.terraform_sp.object_id
}
resource "azurerm_role_assignment" "terraform_kv_admin" {
  for_each             = var.subenvironments
  scope                = module.keyvault_platform[each.key].key_vault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_service_principal.terraform_sp.object_id
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

# # # // Step 07 - Deploy Base and Azure Role Assignments, Definitions and Bindings and Disable All Others
# resource "azurerm_key_vault_access_policy" "devteam" {
#   for_each = var.subenvironments

#   key_vault_id = module.keyvault_platform[each.key].key_vault_id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = azuread_group.developers_group.object_id
#   lifecycle {
#     # prevent_destroy = true
#     ignore_changes  = all
#   }

#   secret_permissions = [
#     "Get",
#     "List",
#     "Set"
#   ]

#   key_permissions = [
#     "Get",
#     "List",
#   ]
# }
# # data "azuread_service_principal" "terraform_sp" {
# #   display_name = "Terraform-SP-Name"  # Replace with your service principal's name
# # }
# # resource "azurerm_key_vault_access_policy" "terraform_sp_policy" {
# #   for_each     = var.subenvironments
# #   key_vault_id = module.keyvault_platform[each.key].key_vault_id
# #   tenant_id    = data.azurerm_client_config.current.tenant_id
# # #   object_id    = module.aks.object_id
# #   object_id = azuread_group.developers_group.object_id
# #   lifecycle {
# #     # prevent_destroy = true
# #     ignore_changes  = all
# #   }

# # #   object_id    = data.azuread_service_principal.terraform_sp.object_id

# #   secret_permissions = [
# #     "Get",
# #     "List",
# #     "Set"
# #   ]

# #   key_permissions = [
# #     "Get",
# #     "List"
# #   ]
# # }