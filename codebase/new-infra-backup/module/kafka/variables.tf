variable "env" {}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}

variable "workspace_prefix" {
  type = string
}

variable "workspace_env" {
  type = string
}

variable "partner_name" {
  default = "Bankifi"
}

variable "name_prefix" {
  description = "Name prefix to be used in the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "storage_account_name" {
  description = "Storage account name"
  type        = string
  default     = null
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "deployment" {
  description = "Deployment mode for the platform deployment"
  type        = string
  default     = "Basic"
}

variable "k8s_cluster_id" {
  description = "Identifier of the K8S resource for the cluster"
  type        = string
}

variable "k8s_common_labels" {
  description = "Common K8S labels for resources"
  type        = map(string)
  default     = {}
}

variable "vnet_name" {
  description = "Name of the Virtual Network where the platform is being deployed"
  type        = string
}

variable "subnet_id" {
  description = "Identifier of the subnet where the platform lives"
  type        = string
}

variable "firewall_name" {
  description = "Name of the Firewall for egress communications"
  type        = string
}

variable "key_vault_id" {
  description = "Identifier of the KeyVault for the platform"
  type        = string
}

variable "key_vault_name" {
  description = "Name of the KeyVault for the platform"
  type        = string
}

// MongoDB

variable "mongodbatlas_org_id" {
  description = "MongoDB Atlas Organisation ID"
  type        = string
}

variable "mongodb_version" {
  description = "MongoDB Version"
  type        = string
  default     = "6.0"
}

variable "mongodb_databases" {
  description = "Names of the MongoDB databases that need to be accessed"
  type        = list(string)
  default     = []
}

variable "mongodbatlas_adminteam" {
  description = "Team ID for Admin Access"
  type        = string
}

variable "mongodbatlas_devteam" {
  description = "Team ID for Developers Access"
  type        = string
}

variable "atlas_cidr_block" {
  description = "CIDR block for the Atlas peering connection"
  type        = string
}

variable "atlas_region" {
  description = "MongoDB Atlas Region"
  type        = string
}

variable "role_names" {
  description = "List of developer access roles to the mongodb project"
  type        = list(string)
  default     = ["GROUP_DATA_ACCESS_READ_ONLY"]
}

// Node pool parameters

variable "node_pool_min_size" {
  type        = number
  description = "Minimum number of VMs available in the dedicated pool"
  default     = 1
}

variable "node_pool_max_size" {
  type        = number
  description = "Maximum number of VMs available in the dedicated pool"
  default     = 2
}

variable "node_pool_node_size" {
  type        = string
  description = "Drone runner VM size"
  default     = "Standard_DS2_v2"
}

variable "namespace_name" {
  type        = string
  description = "K8S namespace subenvironment platform name"
}

variable "node_pool_taint" {
  type        = string
  description = "Node pool taint"
}

variable "create_node_pool" {
  description = "Whether this module should create its own node pool or not"
  type        = bool
  default     = true
}

variable "network_rule_collection_priority" {
  description = "Priority of the network rule collection"
  type        = number
}

variable "application_rule_collection_priority" {
  description = "Priority of the application rule collection"
  type        = number
}

variable "resource_name" {
  description = "Top level resource name"
  type = string
}

variable "zone_redundant" {
  description = "Whether the EventHubs should be created across availability zones"
  type        = bool
  default = true 
}

variable "min_instance_size" {
  description = "MongoDB Atlas minimum node size"
  type = string
  default = "M10"
}

variable "max_instance_size" {
  description = "MongoDB Atlas maximum node size"
  type = string
  default = "M40" 
}


// Kubernetes manifests workaround
variable "create_manifests" {
  description = "Workaround for creating manifests in a separate apply"
  type = bool 
}
