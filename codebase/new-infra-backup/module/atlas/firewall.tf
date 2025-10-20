resource "azurerm_firewall_network_rule_collection" "mongodb_atlas" {
  name = "${var.name_prefix}-${var.namespace_name}-mongodb-atlas-network"
  azure_firewall_name = var.firewall_name
  resource_group_name = data.azurerm_resource_group.mongodb.name
  
  priority = var.network_rule_collection_priority
  action   = "Allow"

  rule {
    name                  = "mongodb-cluster-hosts"
    source_addresses      = ["*"]
    destination_addresses = [var.atlas_cidr_block]
    destination_ports     = ["27015-27017"]
    protocols             = ["TCP"]
  }
}

resource "azurerm_firewall_application_rule_collection" "mongodb_atlas" {
  name = "${var.name_prefix}-${var.namespace_name}-mongodb-atlas-apis"
  azure_firewall_name = var.firewall_name
  resource_group_name = data.azurerm_resource_group.mongodb.name
  
  priority = var.application_rule_collection_priority
  action   = "Allow"

  rule {
    name             = "api-agents-mongodb-com"
    source_addresses = ["*"]
    target_fqdns     = ["api-agents.mongodb.com"]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name             = "backup-mongodb-com"
    source_addresses = ["*"]
    target_fqdns     = [
      "api-backup.mongodb.com",
      "restore-backup.mongodb.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }

}