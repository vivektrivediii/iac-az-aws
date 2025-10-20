resource "azuread_group" "bankifi_dev_group" {
  display_name     = "${title(var.namespace_name)} ${var.resource_name} Platform Devs"
  security_enabled = true
}

resource "kubernetes_role_binding" "bankifi_dev_ns_role_binding" {
  metadata {
    labels    = local.k8s_common_labels
    name      = "${var.namespace_name}-${var.resource_name}-devs"
    namespace = kubernetes_namespace.bankifi.id
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "view"
  }

  subject {
    kind = "Group"
    name = azuread_group.bankifi_dev_group.object_id
  }
}

resource "azurerm_role_assignment" "k8s_dev_assignment" {
  principal_id         = azuread_group.bankifi_dev_group.object_id
  scope                = local.k8s_cluster_id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
}

// Mongo DB Administrator

resource "random_password" "mongodb_admin_password" {
  length           = 16
  override_special = "_#.$,"
}

resource "mongodbatlas_database_user" "admin" {
  username   = "${mongodbatlas_project.platform.name}-admin"
  password   = random_password.mongodb_admin_password.result
  project_id = mongodbatlas_project.platform.id

  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "admin"
  }

  roles {
    role_name     = "dbAdminAnyDatabase"
    database_name = "admin"
  }

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }

  roles {
    role_name     = "clusterMonitor"
    database_name = "admin"
  }
}

resource "azurerm_key_vault_secret" "mongodb_admin_password" {
  name         = "mongodb-admin-password"
  value        = random_password.mongodb_admin_password.result
  key_vault_id = var.key_vault_id

  tags = local.tags
}

// Mongo DB Operator

locals {
  mongodb_cluster_address = substr(
    mongodbatlas_cluster.cluster.connection_strings[0].private_srv,
    length("mongodb+srv://"),
    length(mongodbatlas_cluster.cluster.connection_strings[0].private_srv)
  )
  mongodb_operator_creds = "${mongodbatlas_database_user.operator.username}:${urlencode(mongodbatlas_database_user.operator.password)}"
  mongodb_operator_url   = "mongodb+srv://${local.mongodb_operator_creds}@${local.mongodb_cluster_address}/test"
}

resource "random_password" "mongodb_operator_password" {
  length           = 16
  override_special = "_%@"
}

resource "mongodbatlas_database_user" "operator" {
  username   = "${mongodbatlas_project.platform.name}-operator"
  password   = random_password.mongodb_operator_password.result
  project_id = mongodbatlas_project.platform.id

  auth_database_name = "admin"

  roles {
    role_name     = "readAnyDatabase"
    database_name = "admin"
  }
}

resource "azurerm_key_vault_secret" "mongodb_operator_password" {
  name         = "mongodb-operator-password"
  value        = random_password.mongodb_operator_password.result
  key_vault_id = var.key_vault_id

  tags = local.tags
}

resource "azurerm_key_vault_secret" "mongodb_operator_url" {
  name         = "mongodb-operator-url"
  value        = local.mongodb_operator_url
  key_vault_id = var.key_vault_id

  tags = local.tags
}
