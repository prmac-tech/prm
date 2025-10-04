variable "resource_group_name" {
  type        = string
  description = "Resource Group name in Microsoft Azure"
  default = "prmk8s"
}

variable "location" {
  type        = string
  description = "Resources location in Microsoft Azure"
  default = "uksouth"
}

variable "docker_password" {
  description = "Docker password"
  type        = string
  sensitive   = true
}

variable "docker_username" {
  description = "Docker username"
  type        = string
  default = "prmac-tech"
  sensitive   = true
}

variable "docker_server" {
  description = "Docker server"
  type        = string
  default = "ghcr.io"
}

variable "docker_email" {
  description = "Docker email"
  type        = string
  default = "paul.mcphee@gmail.com"
}

variable "cluster_name" {
  type        = string
  description = "AKS name in Microsoft Azure"
  default = "aks-terraform-cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
  default = "1.30.5"
}

variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
  default = 2
}

variable "node_resource_group" {
  type        = string
  description = "Resource Group name for cluster resources in Microsoft Azure"
  default = "aks_terraform_node_resources_rg"
}

#---------------------------------------------------------------------------------------------------
# Storage
#---------------------------------------------------------------------------------------------------
variable "kubernetes_storage_pvc" {
  sensitive   = false
  type        = string
  description = "Kubernetes Storage Class"
  default     = "prm"
}

variable "kubernetes_storage_allocation_size" {
  sensitive   = false
  type        = string
  description = "PostgreSQL Storage Allocation Size"
  default     = "8Gi"
}

#---------------------------------------------------------------------------------------------------
# PostgreSQL
#---------------------------------------------------------------------------------------------------
variable "postgresql_version" {
  sensitive   = false
  type        = string
  description = "PostgreSQL version"
  default     = "14.0.0"
}

variable "postgresql_router_count" {
  sensitive   = false
  type        = number
  description = "Total PostgreSQL Pool"
  default     = 1
}

variable "postgresql_server_count" {
  sensitive   = false
  type        = number
  description = "Total PostgreSQL Server"
  default     = 1
}

#---------------------------------------------------------------------------------------------------
# Authentication
#---------------------------------------------------------------------------------------------------
variable "postgresql_username" {
  sensitive   = false
  description = "Username"
  default     = "postgres"
}

variable "postgresql_password" {
  sensitive   = true
  description = "PostgreSQL Password"
}