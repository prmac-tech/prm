variable "resource_group_name" {
  type        = string
  description = "Resource Group name in Microsoft Azure"
}

variable "location" {
  type        = string
  description = "Resources location in Microsoft Azure"
}

variable "cluster_name" {
  type        = string
  description = "AKS name in Microsoft Azure"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
}

variable "node_resource_group" {
  type        = string
  description = "Resource Group name for cluster resources in Microsoft Azure"
}