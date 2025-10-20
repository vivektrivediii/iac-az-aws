variable "env" {}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}

variable "partner_name" {
  default = "Bankifi"
}

variable "name_prefix" {
  description = "Name prefix to be used in the resources"
  type = string
}

variable "k8s_common_labels" {
  description = "Common K8S labels for resources"
  type        = map(string)
  default     = {}
}

variable "key_vault_id" {
  description = "Identifier of the KeyVault for the platform"
  type        = string
}

variable "mongodbatlas_project_id" {
  description = "MongoDB Atlas Project ID"
  type        = string
}

variable "mongodbatlas_cluster_name" {
  description = "MongoDB Atlas Cluster Name"
  type        = string
}

variable "mongodb_database_name" {
  description = "Names of the MongoDB database that needs to be accessed"
  type        = string
}

variable "namespace_name" {
  type = string
  description = "K8S namespace subenvironment platform name"
}