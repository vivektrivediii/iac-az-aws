# resource "azurerm_storage_container" "mobile_assets" {
#   count = local.cdn_enabled ? 1 : 0

#   name                  = "mobile-assets-${var.namespace_name}-${var.resource_name}"
#   storage_account_name  = data.azurerm_storage_account.general[0].name
#   container_access_type = "private"
# }

# resource "azurerm_cdn_profile" "cdn" {
#   count = local.cdn_enabled ? 1 : 0

#   name                = "${var.namespace_name}-${var.resource_name}-cdn"
#   resource_group_name = data.azurerm_resource_group.bankifi.name
#   // location            = data.azurerm_resource_group.bankifi.location
#   location = "global"
  
#   sku = "Standard_Microsoft"

#   tags = local.tags
# }

# resource "azurerm_cdn_endpoint" "mobile" {
#   count = local.cdn_enabled ? 1 : 0

#   name                = "${var.namespace_name}-${var.resource_name}-mcdn"
#   profile_name        = azurerm_cdn_profile.cdn[0].name
#   resource_group_name = data.azurerm_resource_group.bankifi.name
#   location            = azurerm_cdn_profile.cdn[0].location

#   origin {
#     name      = azurerm_storage_container.mobile_assets[0].name
#     host_name = data.azurerm_storage_account.general[0].primary_blob_host
#   }
#   origin_path = "/${azurerm_storage_container.mobile_assets[0].name}"

#   lifecycle {
#     ignore_changes = all
#   }
# }