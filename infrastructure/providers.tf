terraform {
  backend "azurerm" {
    use_oidc = true
    resource_group_name  = "prm"                    # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "prmstorageacc"          # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"                # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "dev.terraform.tfstate"  # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.5.0"
    }
    azuread = {
      version = ">= 2.26.0" // https://github.com/terraform-providers/terraform-provider-azuread/releases
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
provider "random" {}


provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

provider "kubernetes" {
  load_config_file       = "false"
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}
provider "helm" {
  debug = true
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}
provider "kubectl" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  load_config_file       = false
}
