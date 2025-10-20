resource "azurerm_kubernetes_cluster" "k8s" {
  name                = local.k8s_cluster_name
  location            = local.location
  resource_group_name = data.azurerm_resource_group.aks.name
  dns_prefix          = local.dns_prefix
  kubernetes_version  = var.kubernetes_version
  # node_resource_group = "${var.resource_name}-aks"
  node_os_upgrade_channel = "None"
  image_cleaner_interval_hours = 48

  default_node_pool {
    name                = "system"
    auto_scaling_enabled = true
    max_count           = var.default_node_max_count
    min_count           = var.default_node_min_count
    vm_size             = var.default_node_size
    os_disk_size_gb     = var.default_node_disk_size_gb
    vnet_subnet_id      = azurerm_subnet.k8s.id
    type                = "VirtualMachineScaleSets"

    tags = var.tags
  }

  service_principal {
    client_id     = azuread_service_principal.k8s_service_principal.client_id
    client_secret = azuread_application_password.k8s_secret.value
  }

  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    # managed                = true
    tenant_id              = data.azurerm_client_config.current.tenant_id
    admin_group_object_ids = [var.admin_group_id]
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"

    service_cidr       = var.k8s_service_cidr
    dns_service_ip     = var.k8s_dns_service_ip
    # docker_bridge_cidr = "172.17.0.1/16"
    outbound_type      = "userDefinedRouting"
  }

  azure_policy_enabled             = true
  http_application_routing_enabled = false

  microsoft_defender {
    log_analytics_workspace_id = data.azurerm_log_analytics_workspace.audit.id
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      default_node_pool[0].tags
    ]
  }

  tags = var.tags
}