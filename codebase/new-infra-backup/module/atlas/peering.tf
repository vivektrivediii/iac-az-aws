data "azurerm_virtual_network" "peering_vnet" {
  name                = var.peering_vnet_name
  resource_group_name = data.azurerm_resource_group.mongodb.name
}

// cannot be modified in-place or deleted
// you need to remove either cluster or the whole project as well!
resource "mongodbatlas_network_container" "network_container" {
  project_id       = var.atlas_project_id
  atlas_cidr_block = var.atlas_cidr_block
  provider_name    = local.atlas_provider_name
  region           = local.atlas_region

  lifecycle {
    ignore_changes = all
  }
}

resource "mongodbatlas_network_peering" "peering" {
  project_id            = var.atlas_project_id
  atlas_cidr_block      = mongodbatlas_network_container.network_container.atlas_cidr_block
  container_id          = mongodbatlas_network_container.network_container.container_id
  provider_name         = local.atlas_provider_name
  azure_directory_id    = var.tenant_id
  azure_subscription_id = var.subscription_id
  resource_group_name   = data.azurerm_resource_group.mongodb.name
  vnet_name             = data.azurerm_virtual_network.peering_vnet.name

  depends_on = [
    azurerm_role_assignment.peering_role_assignment,
    azurerm_firewall_application_rule_collection.mongodb_atlas
  ]
}

resource "mongodbatlas_project_ip_access_list" "mongo" {
  project_id = var.atlas_project_id
  cidr_block = data.azurerm_virtual_network.peering_vnet.address_space.0
  comment    = "allow peering access"

  lifecycle {
    ignore_changes = all
  }
}

resource "mongodbatlas_project_ip_access_list" "test" {
  project_id = var.atlas_project_id
  cidr_block = "192.168.1.0/28"
  comment    = "allow p2s vpn peering access"
}