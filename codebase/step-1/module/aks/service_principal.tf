// https://docs.microsoft.com/en-us/azure/aks/kubernetes-service-principal
// https://github.com/terraform-providers/terraform-provider-azuread/issues/40#issuecomment-477076926
// https://github.com/terraform-providers/terraform-provider-azuread/issues/40#issuecomment-500504952

resource "azuread_application" "k8s" {
  display_name = local.k8s_cluster_name
}

resource "azuread_service_principal" "k8s_service_principal" {
  client_id = azuread_application.k8s.client_id
  tags      = [local.location, var.env, var.partner_name]

  lifecycle {
    ignore_changes = [tags]
  }
}

# Generate random string to be used for Service Principal password

resource "time_rotating" "k8s_secret_rotation" {
  rotation_days = 3000
}

resource "azuread_application_password" "k8s_secret" {
  application_id = azuread_application.k8s.id
  rotate_when_changed = {
    rotation = time_rotating.k8s_secret_rotation.id
  }
  lifecycle {
    ignore_changes = [rotate_when_changed]
  }
}

resource "azurerm_key_vault_secret" "k8s_client_id" {
  name         = "k8s-client-id"
  value        = azuread_service_principal.k8s_service_principal.client_id
  key_vault_id = var.key_vault_id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "k8s_client_secret" {
  name         = "k8s-client-secret"
  value        = azuread_application_password.k8s_secret.value
  key_vault_id = var.key_vault_id

  tags = var.tags
}

resource "azurerm_role_assignment" "k8s_vnet_contributor" {
  principal_id         = azuread_service_principal.k8s_service_principal.object_id
  scope                = azurerm_subnet.k8s.id
  role_definition_name = "Network Contributor"
}

data "azurerm_resource_group" "k8s_node_resource_group" {
  name = azurerm_kubernetes_cluster.k8s.node_resource_group

  depends_on = [azurerm_kubernetes_cluster.k8s]
}

resource "azurerm_role_assignment" "global_identity_operator" {
  principal_id         = azuread_service_principal.k8s_service_principal.object_id
  scope                = data.azurerm_resource_group.aks.id
  role_definition_name = "Managed Identity Operator"
}

resource "azurerm_role_assignment" "k8s_identity_operator" {
  principal_id         = azuread_service_principal.k8s_service_principal.object_id
  scope                = data.azurerm_resource_group.k8s_node_resource_group.id
  role_definition_name = "Managed Identity Operator"
  lifecycle {
    ignore_changes = [
      id,
      name,
      role_definition_id,
      scope,
      skip_service_principal_aad_check
    ]
  }
}

resource "azurerm_role_assignment" "k8s_vm_operator" {
  principal_id         = azuread_service_principal.k8s_service_principal.object_id
  scope                = data.azurerm_resource_group.k8s_node_resource_group.id
  role_definition_name = "Virtual Machine Contributor"
  lifecycle {
    ignore_changes = [
      id,
      name,
      role_definition_id,
      scope,
      skip_service_principal_aad_check
    ]
  }
}