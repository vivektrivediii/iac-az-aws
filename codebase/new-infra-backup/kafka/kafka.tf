module "platform_kafka" {
  count = local.deployment_settings_map[var.deployment].kafka_enabled ? 1 : 0

  source  = "app.terraform.io/BankiFi/kafka/azure"
  version = "1.1.0"

  name                = "${var.workspace_prefix}-${var.workspace_env}"
  name_prefix         = var.name_prefix
  resource_group_name = data.azurerm_resource_group.bankifi.name
  env                 = var.env
  tags                = local.tags

  allow_subnet_id = var.subnet_id
//  zone_redundant  = local.deployment_settings_map[var.deployment].kafka_zone_redundant
  capacity        = local.deployment_settings_map[var.deployment].kafka_capacity
}

resource "kubernetes_secret" "kafka_connection" {
  count = local.deployment_settings_map[var.deployment].kafka_enabled ? 1 : 0

  metadata {
    name      = "kafka-connection"
    namespace = kubernetes_namespace.bankifi.id
    labels    = local.k8s_common_labels
  }

  data = {
    host = module.platform_kafka[0].connection_string
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_key_vault_secret" "kafka_connection" {
  count = local.deployment_settings_map[var.deployment].kafka_enabled ? 1 : 0

  name         = "kafka-connection-string"
  value        = module.platform_kafka[0].connection_string
  key_vault_id = var.key_vault_id

  tags = local.tags

  lifecycle {
    ignore_changes = all
  }
}