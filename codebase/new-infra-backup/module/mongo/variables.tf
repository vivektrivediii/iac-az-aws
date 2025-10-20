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

variable "k8s_common_labels" {
  description = "Common K8S labels for resources"
  type        = map(string)
  default     = {}
}

variable "vnet_name" {
  description = "Name of the Virtual Network where the platform is being deployed"
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

// MongoDB

variable "mongodbatlas_org_id" {
  description = "MongoDB Atlas Organisation ID"
  type        = string
}

variable "mongodb_version" {
  description = "MongoDB Version"
  type        = string
  default     = "4.2"
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

variable "role_names" {
  description = "List of developer access roles to the mongodb project"
  type        = list(string)
  default     = ["GROUP_DATA_ACCESS_READ_ONLY"]
}

variable "namespace_name" {
  type        = string
  description = "K8S namespace subenvironment platform name"
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
