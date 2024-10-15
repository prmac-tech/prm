variable "resource_group_name" {
  type        = string
  description = "Resource Group name in Microsoft Azure"
  default = "aks_terraform_rg"
}

variable "location" {
  type        = string
  description = "Resources location in Microsoft Azure"
  default = "uksouth"
}

variable "cluster_name" {
  type        = string
  description = "AKS name in Microsoft Azure"
  default = "aks-terraform-cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
  default = "1.31.1"
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