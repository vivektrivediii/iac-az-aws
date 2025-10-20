// Platform super user
resource "random_password" "superuser_password" {
  length = 32
}

resource "azurerm_key_vault_secret" "superuser_password" {
  name         = "superuser-password"
  value        = random_password.superuser_password.result
  key_vault_id = var.key_vault_id

  tags = local.tags
}

// Generate Signature
resource "azurerm_key_vault_key" "bankifi_signature" {
  name         = "bankifi-signature"
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  tags = local.tags
}

// Generate JWT signature key
resource "random_password" "jwt_shared_key" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "jwt_shared_key" {
  name         = "jwt-shared-key"
  value        = random_password.jwt_shared_key.result
  key_vault_id = var.key_vault_id

  tags = local.tags
}

// Step 05: Disable All kubernetes-alpha in workspace/resources/modules with provider = kubernetes-alpha
// Step 13: Deploy BankiFi Platform

resource "kubernetes_manifest" "bankifi_signature" {
  count = var.create_manifests ? 1 : 0

  manifest = yamldecode(templatefile("${path.module}/files/akv2k8s/key.k8s.yaml", {
    name          = azurerm_key_vault_key.bankifi_signature.name
    namespace     = kubernetes_namespace.bankifi.id
    keyvault_name = var.key_vault_name
    data_key      = "key"
  }))

  // force field manager conflicts to be overridden
  # field_manager {
  #   force_conflicts = true
  # }

  depends_on = [azurerm_key_vault_key.bankifi_signature]
}


// Step 05: Disable All kubernetes-alpha in workspace/resources/modules with provider = kubernetes-alpha
// Step 13: Deploy BankiFi Platform

resource "kubernetes_manifest" "jwt_shared_key" {
  count = var.create_manifests ? 1 : 0

  manifest = yamldecode(templatefile("${path.module}/files/akv2k8s/single-secret.k8s.yaml", {
    name          = azurerm_key_vault_secret.jwt_shared_key.name
    namespace     = kubernetes_namespace.bankifi.id
    keyvault_name = var.key_vault_name
    data_key      = "key"
  }))

  // force field manager conflicts to be overridden
  # field_manager {
  #   force_conflicts = true
  # }

  depends_on = [azurerm_key_vault_secret.jwt_shared_key]
}
