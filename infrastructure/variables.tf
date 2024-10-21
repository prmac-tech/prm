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
  value = "pmcphee77"
  sensitive   = true
}

variable "docker_server" {
  description = "Docker server"
  type        = string
  value = "ghcr.io"
}

variable "docker_email" {
  description = "Docker email"
  type        = string
  value = "paul.mcphee@gmail.com"
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