data "azuread_service_principal" "mongo_service_principal" {
  // the application id is provided by MongoDB Atlas
  client_id = "e90a1407-55c3-432d-9cb1-3638900a9d22"
}

resource "azurerm_role_definition" "peering_role" {
  name              = "AtlasPeering-${var.namespace_name}/${var.subscription_id}/${var.resource_group_name}/${var.peering_vnet_name}"
  description       = "Grants MongoDB access to manage peering connections on network ${var.peering_vnet_name}"
  assignable_scopes = ["/subscriptions/${var.subscription_id}", data.azurerm_virtual_network.peering_vnet.id]
  scope             = "/subscriptions/${var.subscription_id}"
  
  permissions {
    actions = [
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/read",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/write",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/delete",
      "Microsoft.Network/virtualNetworks/peer/action"
    ]
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_role_assignment" "peering_role_assignment" {
  principal_id       = data.azuread_service_principal.mongo_service_principal.object_id
  scope              = data.azurerm_virtual_network.peering_vnet.id
  role_definition_id = azurerm_role_definition.peering_role.role_definition_resource_id
  
  lifecycle {
    ignore_changes = all
  }
}