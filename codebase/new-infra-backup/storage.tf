# /* TODO: Create s Storage Account for ????? */
resource "azurerm_storage_account" "general" {
  name                            = "${var.name_prefix}${var.env}${var.primary_location}"
  resource_group_name             = azurerm_resource_group.workspace.name
  location                        = azurerm_resource_group.workspace.location
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  https_traffic_only_enabled       = true
  allow_nested_items_to_be_public = false
  cross_tenant_replication_enabled = false

  tags = local.tags
  depends_on = [azurerm_resource_group.workspace]
}
