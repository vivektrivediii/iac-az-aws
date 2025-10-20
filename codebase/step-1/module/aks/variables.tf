variable "env" {}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "k8s_common_labels" {
  type = map(string)
}

variable "resource_group_name" {
  description = "Name of the Virtual Network Resource Group"
  type        = string
}

variable "location" {
  type = string
}

variable "key_vault_id" {
  description = "ID of the KeyVault where to store secrets"
  type        = string
}

variable "admin_group_id" {
  description = "Identifier of the admin group"
  type        = string
}

variable "dns_prefix" {
  default     = null
  description = "custom kubernetes dns name"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "default_node_max_count" {
  type        = number
  description = "Maximum number of VMs for the default node pool"
  default     = 5
}

variable "default_node_min_count" {
  type        = number
  description = "Maximum number of VMs for the default node pool"
  default     = 3
}

variable "default_node_size" {
  type        = string
  description = "Default node size"
  default     = "Standard_DS2_v2"
}

variable "default_node_disk_size_gb" {
  type        = number
  description = "Disk size of the default nodes"
  default     = 32
}

variable "log_analytics_workspace_id" {
  description = "Identifier for the Azure Log Analytics Workspace"
  type        = string
  default     = null
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable "log_analytics_workspace_location" {
  default = null
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing
variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}

variable "partner_name" {
  default = "Bankifi"
}

variable "name_prefix" {
  default = "bnkf"
}

variable "aad_pod_identity_version" {
  description = "Chart version for the AAD Pod Identity"
  type        = string
  default     = "4.1.8"
}

variable "firewall_name" {
  description = "Firewall name where to add the Network rules"
  type        = string
}

variable "firewall_private_ip_address" {
  description = "Firewall Private IP for next hop in K8S subnet"
  type        = string
}

variable "k8s_subnet_address_prefixes" {
  description = "List of IP prefixes for the K8S subnet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "k8s_additional_service_endpoints" {
  description = "Additional Service Endpoints for K8S subnet"
  type        = list(string)
  default     = []
}

variable "k8s_service_cidr" {
  description = "K8S Service CIDR"
  type        = string
  default     = "10.2.0.0/24"
}

variable "k8s_dns_service_ip" {
  description = "K8S DNS Service IP"
  type        = string
  default     = "10.2.0.10"
}

variable "k8s_additional_routes" {
  description = "Additional Rules for k8s Route table"
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
  default = []
}

variable "resource_name" {
  description = "Top level resource name"
  type = string
}