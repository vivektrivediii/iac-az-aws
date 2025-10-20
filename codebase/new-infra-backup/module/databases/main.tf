terraform {
  required_version = ">= 1.13.0"

  required_providers {
    random = {
      version = ">= 3.6.3"
    }
    kubernetes = {
      version = ">= 2.35.1"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = ">= 1.24.0"
    }
  }
}

# locals {
#   database_resource_name = replace(var.mongodb_database_name, "_", "-")
#   database_username      = mongodbatlas_database_user.user.username
#   database_password      = mongodbatlas_database_user.user.password
#   database_creds         = "${local.database_username}:${urlencode(local.database_password)}"

#   mongodb_cluster_address = substr(
#     data.mongodbatlas_cluster.cluster.connection_strings[0].private_srv,
#     length("mongodb+srv://"),
#     length(data.mongodbatlas_cluster.cluster.connection_strings[0].private_srv)
#   )
#   mongodb_connection_url = "mongodb+srv://${local.database_creds}@${local.mongodb_cluster_address}/${var.mongodb_database_name}?retryWrites=true&w=majority"

#   mongodb_cluster_address_std = substr(
#     data.mongodbatlas_cluster.cluster.connection_strings[0].standard_srv,
#     length("mongodb+srv://"),
#     length(data.mongodbatlas_cluster.cluster.connection_strings[0].standard_srv)
#   )
#   mongodb_connection_url_std = "mongodb+srv://${local.database_creds}@${local.mongodb_cluster_address_std}/${var.mongodb_database_name}?retryWrites=true&w=majority"

#   k8s_common_labels = var.k8s_common_labels
#   tags              = var.tags
# }

locals {
  database_resource_name = replace(var.mongodb_database_name, "_", "-")
  database_username      = mongodbatlas_database_user.user.username
  database_password      = mongodbatlas_database_user.user.password
  database_creds         = "${local.database_username}:${urlencode(local.database_password)}"

  mongodb_cluster_address = try(
    substr(
      data.mongodbatlas_cluster.cluster.connection_strings[0].private_srv,
      length("mongodb+srv://"),
      length(data.mongodbatlas_cluster.cluster.connection_strings[0].private_srv)
    ),
    ""
  )

  mongodb_connection_url = try(
    "mongodb+srv://${local.database_creds}@${local.mongodb_cluster_address}/${var.mongodb_database_name}?retryWrites=true&w=majority",
    ""
  )

  mongodb_cluster_address_std = try(
    substr(
      data.mongodbatlas_cluster.cluster.connection_strings[0].standard_srv,
      length("mongodb+srv://"),
      length(data.mongodbatlas_cluster.cluster.connection_strings[0].standard_srv)
    ),
    ""
  )

  mongodb_connection_url_std = try(
    "mongodb+srv://${local.database_creds}@${local.mongodb_cluster_address_std}/${var.mongodb_database_name}?retryWrites=true&w=majority",
    ""
  )

  k8s_common_labels = var.k8s_common_labels
  tags              = var.tags
}



###change vivek
# locals {
#   database_resource_name = replace(var.mongodb_database_name, "_", "-")
#   database_username      = mongodbatlas_database_user.user.username
#   database_password      = mongodbatlas_database_user.user.password
#   database_creds         = "${local.database_username}:${urlencode(local.database_password)}"

#   mongodb_cluster_address = substr(
#     data.mongodbatlas_cluster.cluster.connection_strings[0].private_srv,
#     length("mongodb+srv://"),
#     length(data.mongodbatlas_cluster.cluster.connection_strings[0].private_srv)
#   )
#   mongodb_connection_url = "mongodb+srv://${local.database_creds}@${local.mongodb_cluster_address}/${var.mongodb_database_name}?retryWrites=true&w=majority"

#   mongodb_cluster_address_std = substr(
#     data.mongodbatlas_cluster.cluster.connection_strings[0].standard_srv,
#     length("mongodb+srv://"),
#     length(data.mongodbatlas_cluster.cluster.connection_strings[0].standard_srv)
#   )
#   mongodb_connection_url_std = "mongodb+srv://${local.database_creds}@${local.mongodb_cluster_address_std}/${var.mongodb_database_name}?retryWrites=true&w=majority"

#   k8s_common_labels = var.k8s_common_labels
#   tags              = var.tags
# }

data "mongodbatlas_cluster" "cluster" {
  project_id = var.mongodbatlas_project_id
  name       = var.mongodbatlas_cluster_name
}
