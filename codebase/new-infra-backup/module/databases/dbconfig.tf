resource "kubernetes_secret" "mongodb_db_config" {
  metadata {
    name      = "mongo-${local.database_resource_name}"
    namespace = var.namespace_name
    labels    = local.k8s_common_labels
  }

  data = {
    username     = local.database_username
    password     = local.database_password
    private_url  = local.mongodb_connection_url
    standard_url = local.mongodb_connection_url_std

    // legacy secret key, exists just for backwards compatibility - should be replaced by `private_url`.
    host = local.mongodb_connection_url
  }
  
  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_key_vault_secret" "mongodb_db_password" {
  name         = "mongodb-${local.database_resource_name}-password"
  value        = local.database_password
  key_vault_id = var.key_vault_id

  tags = local.tags
}
