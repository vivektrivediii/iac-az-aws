resource "azurerm_subnet" "k8s" {
  name                 = "${var.resource_name}-aks-subnet"
  resource_group_name  = data.azurerm_resource_group.aks.name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.k8s_subnet_address_prefixes
  private_endpoint_network_policies = "Enabled"
  service_endpoints = local.k8s_service_endpoints
}

resource "azurerm_route_table" "k8s" {
  name                          = "${var.resource_name}-aks-route-table"
  location                      = data.azurerm_resource_group.aks.location
  resource_group_name           = data.azurerm_resource_group.aks.name
  bgp_route_propagation_enabled = true

  dynamic "route" {
    for_each = var.k8s_additional_routes
    content {
      name                   = "${var.resource_name}-aks-route-table-${route.value["name"]}"
      address_prefix         = route.value["address_prefix"]
      next_hop_type          = route.value["next_hop_type"]
      next_hop_in_ip_address = route.value["next_hop_in_ip_address"]
    }
  }

  route {
    name                   = "${var.resource_name}-aks-outbound"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "k8s" {
  subnet_id      = azurerm_subnet.k8s.id
  route_table_id = azurerm_route_table.k8s.id
}