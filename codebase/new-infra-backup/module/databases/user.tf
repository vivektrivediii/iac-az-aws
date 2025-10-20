resource "random_password" "mongodb_user" {
  length = 16
  override_special = "_#.$,"
}

resource "mongodbatlas_database_user" "user" {
  username   = "${var.name_prefix}-${var.namespace_name}-${local.database_resource_name}"
  password   = random_password.mongodb_user.result
  project_id = var.mongodbatlas_project_id
  
  auth_database_name = "admin"

  roles {
    role_name     = "dbAdmin"
    database_name = var.mongodb_database_name
  }

  roles {
    role_name     = "readWrite"
    database_name = var.mongodb_database_name
  }

  scopes {
    name = var.mongodbatlas_cluster_name
    type = "CLUSTER"
  }
}
