# # // Step 9 - Deploy DNS for Environment Type
# # // E.g. sbox.bankifi.com
# resource "azurerm_dns_ns_record" "env_dns_zone" {
#   provider            = azurerm
#   name                = var.appname
#   zone_name           = "${var.domain_name_type}.${var.root_domain}"
#   resource_group_name = var.dns_resource_group
#   ttl                 = 300
#   records             = data.azurerm_dns_zone.env_dns_zone.name_servers

#   tags = local.tags
# }

# # // Step 9 - Deploy DNS for Environment Type Sub-Domain
# # //E.g. sbox.bankifi.com
# # resource "azurerm_dns_zone" "env_dns_zone" {
# #   provider            = azurerm
# #   name                = "${var.domain_name_type}.${var.root_domain}"
# #   resource_group_name = var.dns_resource_group

# #   tags = local.tags
# # }
# data "azurerm_dns_zone" "env_dns_zone" {
#   name                = "${var.domain_name_type}.${var.root_domain}"
#   resource_group_name = var.dns_resource_group
# }

# // E.g. sbox.bankifi.com
# resource "azurerm_dns_a_record" "env_apex_record" {
#   provider            = azurerm
#   name                = "@"
#   zone_name           = "${var.domain_name_type}.${var.root_domain}"
#   resource_group_name = var.dns_resource_group
#   ttl                 = 300
#   records             = [module.gateway.gateway_ip_address]

#   tags = local.tags
# }

# // Create Wildcard Record and link to Application Gateway
# // E.g. *.sbox.bankifi.com
# resource "azurerm_dns_a_record" "env_wildcard_record" {
#   provider            = azurerm
#   name                = "*"
#   zone_name           = "${var.domain_name_type}.${var.root_domain}"
#   resource_group_name = var.dns_resource_group
#   ttl                 = 300
#   target_resource_id  = azurerm_dns_a_record.env_apex_record.id

#   tags = local.tags
# }

# # // Step 11 - DNS, Application Gateway, Ingress Controller

# # // Environment Development DNS Records

# # // Create Development Name Server (NS) Record
# # // E.g. dev.sbox.bankifi.com of type NS
# resource "azurerm_dns_ns_record" "develop_dns_nameservers" {
#   for_each = var.subenvironments

#   provider            = azurerm
#   name                = each.value.namespace_name
#   zone_name           = "${var.domain_name_type}.${var.root_domain}"
#   resource_group_name = var.dns_resource_group
#   ttl                 = 300
#   records             = azurerm_dns_zone.develop_dns_zone[each.key].name_servers

#   tags = local.tags
# }

# resource "azurerm_dns_zone" "develop_dns_zone" {
#   for_each = var.subenvironments

#   provider            = azurerm
#   name                = "${each.value.namespace_name}.${var.domain_name_type}.${var.root_domain}"
#   resource_group_name = var.dns_resource_group

#   tags = local.tags
# }

# // Create Development Root DNS Record and Link to Application Gateway
# // E.g. dev.sbox.bankifi.com
# resource "azurerm_dns_a_record" "develop_apex_record" {
#   for_each = var.subenvironments

#   provider            = azurerm
#   name                = "@"
#   zone_name           = "${each.value.namespace_name}.${var.domain_name_type}.${var.root_domain}"
#   resource_group_name = var.dns_resource_group
#   ttl                 = 300
#   records             = [module.gateway.gateway_ip_address]

#   tags = local.tags
# }

# // Create Wildcard Record and link to Application Gateway
# // E.g. *.dev.sbox.bankifi.com
# resource "azurerm_dns_a_record" "develop_wildcard_record" {
#   for_each = var.subenvironments

#   provider            = azurerm
#   name                = "*"
#   zone_name           = "${each.value.namespace_name}.${var.domain_name_type}.${var.root_domain}"
#   resource_group_name = var.dns_resource_group
#   ttl                 = 300
#   target_resource_id  = azurerm_dns_a_record.develop_apex_record[each.key].id

#   tags = local.tags
# }

# # // ***************************************************
# # // Environment Testing DNS Records

# # resource "azurerm_dns_zone" "test_dns_zone" {
# #   provider            = azurerm
# #   name                = "${var.appname}.${local.test_domain}"
# #   resource_group_name = var.dns_resource_group

# #   tags = local.tags
# # }

# # resource "azurerm_dns_a_record" "test_apex_record" {
# #   provider            = azurerm
# #   name                = "@"
# #   zone_name           = "${var.appname}.${local.test_domain}"
# #   resource_group_name = var.dns_resource_group
# #   ttl                 = 300
# #   records             = [module.gateway.gateway_ip_address]

# #   tags = local.tags
# # }

# # // Create Wildcard Record and link to Application Gateway
# # // E.g. *.asb.test.bankifi.com
# # resource "azurerm_dns_a_record" "test_wildcard_record" {
# #   provider            = azurerm
# #   name                = "*"
# #   zone_name           = "${var.appname}.${local.test_domain}"
# #   resource_group_name = var.dns_resource_group
# #   ttl                 = 300
# #   target_resource_id  = azurerm_dns_a_record.test_apex_record.id

# #   tags = local.tags
# # }

# # // ***************************************************
# // Environment Production DNS Records

# # // Create DNS Server Entries
# # resource "azurerm_dns_ns_record" "prod_dns_nameservers" {
# #   provider            = azurerm
# #   name                = "${var.appname}"
# #   zone_name           = "${var.appname}.${var.root_domain}"
# #   resource_group_name = var.dns_resource_group
# #   ttl                 = 300
# #   records             = azurerm_dns_zone.prod_dns_zone.name_servers

# #   tags                = local.tags
# # }
# # resource "azurerm_dns_zone" "prod_dns_zone" {
# #   provider            = azurerm
# #   name                = "${var.appname}.${var.root_domain}"
# #   resource_group_name = var.dns_resource_group

# #   tags                = local.tags
# # }

# # // Create Default Root DNS Record and Link to Application Gateway
# # resource "azurerm_dns_a_record" "prod_apex_record" {
# #   provider            = azurerm
# #   name                = "@"
# #   zone_name           = "${var.appname}.${var.root_domain}"
# #   resource_group_name = var.dns_resource_group
# #   ttl                 = 300
# #   records             = [module.gateway.gateway_ip_address]

# #   tags                = local.tags
# # }

# # // Create Wildcard Record and link to Application Gateway
# # // E.g. *.asb.bankifi.com, *.asb.partner.bankifi.com
# # resource "azurerm_dns_a_record" "prod_wildcard_record" {
# #   provider            = azurerm
# #   name                = "*"
# #   zone_name           = "${var.appname}.${var.root_domain}"
# #   resource_group_name = var.dns_resource_group
# #   ttl                 = 300
# #   target_resource_id  = azurerm_dns_a_record.prod_apex_record.id

# #   tags                = local.tags
# # }