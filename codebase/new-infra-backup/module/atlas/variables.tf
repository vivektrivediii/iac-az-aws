variable "env" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "name_prefix" {
  description = "Name prefix to be used in the resources"
  type = string
}

variable "resource_group_name" {
  description = "Name of the K8S Resource Group"
  type        = string
}

variable "atlas_project_id" {
  description = "MongoDB Atlas Project ID"
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

variable "peering_vnet_name" {
  description = "Virtual Network name for the peering connection"
  type        = string
}

variable "firewall_name" {
  description = "Name of the firewall for additional rules"
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

variable "namespace_name" {
  description = "K8S namespace subenvironment platform name"
  type        = string
}

variable "network_rule_collection_priority" {
  description = "Priority of the network rule collection"
  type = number
}

variable "application_rule_collection_priority" {
  description = "Priority of the application rule collection"
  type = number
}