
# // Step 7 - Azure Role Assignments, Definitions and Bindings

# // Create Azure Role Assignment Resource for Admins
resource "azuread_group" "admin_group" {
  display_name     = "${var.partner_name} ${title(var.env)} Admins"
  security_enabled = true
}

// Create Azure Role Assignment Resource for Admins
resource "azurerm_role_assignment" "admin_subscription" {
  principal_id         = azuread_group.admin_group.object_id
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
}

// TODO: This is a work around to allow to take the members of the general Development Team group into the Developers Group,
// it should be changed once Azure allows to assign roles to Office 365 groups
// Create Azure Role Assignment Resource for Developers
resource "azuread_group" "developers_group" {
  display_name     = "${var.partner_name} ${title(var.env)} Developers"
  security_enabled = true
}

data "azuread_group" "office365_developers" {
  display_name = "Development"
}

// Create Azure Role Assignment Resource for Developers
resource "azuread_group_member" "office365_developer" {
  count            = length(data.azuread_group.office365_developers.members)
  group_object_id  = azuread_group.developers_group.object_id
  member_object_id = data.azuread_group.office365_developers.members[count.index]
}

// Create Azure Role Assignment Resource for Developers
resource "azurerm_role_assignment" "developers_subscription" {
  principal_id         = azuread_group.developers_group.object_id
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
}

// Create Azure Role Assignment Resource for the Infra and Platform Keyvaults for Admin Group
resource "azurerm_role_assignment" "access_to_infra_keyvalut" {
  scope                = module.keyvault_infra.key_vault_id
  role_definition_name = "Owner"
  principal_id         = azuread_group.admin_group.object_id
}

resource "azurerm_role_assignment" "access_to_platform_keyvalut" {
  for_each = var.subenvironments

  scope                = module.keyvault_platform[each.key].key_vault_id
  role_definition_name = "Owner"
  principal_id         = azuread_group.admin_group.object_id
}


# // Step 10 - Kubernetes Role Assignments, Definitions and Bindings

# resource "azurerm_role_assignment" "k8s_user_assignment" {
#   principal_id         = azuread_group.developers_group.object_id
#   scope                = module.aks.cluster_id
#   role_definition_name = "Azure Kubernetes Service Cluster User Role"
# }

# // Create Role Assignment Resource for the Cluster for Developers Group (AAD)
# resource "azurerm_role_assignment" "k8s_user_rbac_viewer_assignment" {
#   principal_id         = azuread_group.developers_group.object_id
#   scope                = module.aks.cluster_id
#   role_definition_name = "Azure Kubernetes Service RBAC Reader"
# }

# resource "kubernetes_cluster_role_binding" "cluster_dev_role_binding" {
#   metadata {
#     labels = local.k8s_common_labels
#     name   = "BankiFi Developers"
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = "view"
#   }

#   subject {
#     kind = "Group"
#     name = azuread_group.developers_group.object_id
#   }
# }
