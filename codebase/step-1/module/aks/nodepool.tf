######Add additional node pool
# --------------------------
# User Node Pool
# --------------------------
resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "usernp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = var.user_node_size
  node_count            = var.user_node_count
  min_count             = var.user_node_min_count
  max_count             = var.user_node_max_count
#   enable_auto_scaling   = true
  os_disk_size_gb       = var.user_node_disk_size_gb
  vnet_subnet_id        = azurerm_subnet.k8s.id
  mode                  = "User"
  orchestrator_version  = var.kubernetes_version

#   tags = var.tags
}

# --------------------------
# Spot Node Pool
# --------------------------
resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  name                  = "spotnp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = var.spot_node_size
  node_count            = var.spot_node_count
  min_count             = var.spot_node_min_count
  max_count             = var.spot_node_max_count
#   enable_auto_scaling   = true
  os_disk_size_gb       = var.spot_node_disk_size_gb
  vnet_subnet_id        = azurerm_subnet.k8s.id
  mode                  = "User"
  orchestrator_version  = var.kubernetes_version

  priority              = "Spot"
  eviction_policy       = "Delete" # or "Deallocate"
  spot_max_price        = -1       # -1 means pay up to on-demand price

#   tags = merge(var.tags, {
#     "nodepool_type" = "spot"
#   })
}


###
# --------------------------
# User Node Pool Variables
# --------------------------
variable "user_node_size" {
  description = "VM size for the user node pool"
  type        = string
  default     = "Standard_D4s_v5"
}

variable "user_node_count" {
  description = "Initial node count for the user node pool"
  type        = number
  default     = 1
}

variable "user_node_min_count" {
  description = "Minimum number of nodes in the user node pool"
  type        = number
  default     = 1
}

variable "user_node_max_count" {
  description = "Maximum number of nodes in the user node pool"
  type        = number
  default     = 3
}

variable "user_node_disk_size_gb" {
  description = "OS disk size (GB) for the user node pool"
  type        = number
  default     = 128
}

# --------------------------
# Spot Node Pool Variables
# --------------------------
variable "spot_node_size" {
  description = "VM size for the spot node pool"
  type        = string
  default     = "Standard_D4s_v5"
}

variable "spot_node_count" {
  description = "Initial node count for the spot node pool"
  type        = number
  default     = 1
}

variable "spot_node_min_count" {
  description = "Minimum number of nodes in the spot node pool"
  type        = number
  default     = 0
}

variable "spot_node_max_count" {
  description = "Maximum number of nodes in the spot node pool"
  type        = number
  default     = 5
}

variable "spot_node_disk_size_gb" {
  description = "OS disk size (GB) for the spot node pool"
  type        = number
  default     = 128
}

######

