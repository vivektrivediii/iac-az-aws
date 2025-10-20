resource "mongodbatlas_project" "platform" {
  name   = "${lower(var.workspace_prefix)}-${var.workspace_env}"
  org_id = var.mongodbatlas_org_id

  teams {
    team_id    = data.mongodbatlas_team.admin.team_id
    role_names = ["GROUP_DATA_ACCESS_ADMIN", "GROUP_CLUSTER_MANAGER"]
  }
  
  dynamic "teams" {
    for_each = var.env != "prod" ? toset([1]) : toset([])
    content {
      team_id    = data.mongodbatlas_team.admin.team_id
      role_names = var.role_names
    }
  }
}

module "mongodb_atlas" {
  source  = "./../atlas"
  # source  = "app.terraform.io/BankiFi/mongodbatlas/azure"
  # version = "0.4.2"

  name_prefix         = var.resource_name
  resource_group_name = data.azurerm_resource_group.bankifi.name
  env                 = var.env
  tags                = local.tags
  atlas_cidr_block    = var.atlas_cidr_block
  atlas_project_id    = mongodbatlas_project.platform.id
  tenant_id           = var.tenant_id
  subscription_id     = var.subscription_id
  firewall_name       = var.firewall_name
  atlas_region        = "ukwest"
  namespace_name                       = var.namespace_name
  network_rule_collection_priority     = var.network_rule_collection_priority
  application_rule_collection_priority = var.application_rule_collection_priority

  peering_vnet_name = var.vnet_name
}

resource "mongodbatlas_cluster" "cluster" {
  project_id = mongodbatlas_project.platform.id
  name       = "${var.workspace_prefix}-${var.workspace_env}-main"

  mongo_db_major_version = var.mongodb_version

  num_shards         = local.deployment_settings_map[var.deployment].mongodb_num_shards
  replication_factor = local.deployment_settings_map[var.deployment].mongodb_replication_factor

  auto_scaling_disk_gb_enabled = true
  auto_scaling_compute_enabled = true
  auto_scaling_compute_scale_down_enabled = true
  provider_auto_scaling_compute_max_instance_size = var.max_instance_size
  provider_auto_scaling_compute_min_instance_size = var.min_instance_size


  provider_name               = module.mongodb_atlas.atlas_provider_name
  provider_instance_size_name = var.min_instance_size
  provider_region_name        = module.mongodb_atlas.atlas_region
  cloud_backup                = local.deployment_settings_map[var.deployment].mongodb_backup_enabled

  lifecycle {
    ignore_changes = [provider_instance_size_name]
  }

  depends_on = [module.mongodb_atlas]
}

module "mongodb_databases" {
  for_each = zipmap(var.mongodb_databases, var.mongodb_databases)
  source  = "./../databases"
  # source  = "app.terraform.io/BankiFi/database/mongodbatlas"
  # version = "0.4.1"

  name_prefix       = var.name_prefix
  env               = var.env
  tags              = local.tags
  k8s_common_labels = local.k8s_common_labels

  namespace_name = var.namespace_name
  key_vault_id   = var.key_vault_id

  mongodbatlas_project_id   = mongodbatlas_project.platform.id
  mongodbatlas_cluster_name = mongodbatlas_cluster.cluster.name
  mongodb_database_name     = each.key
}