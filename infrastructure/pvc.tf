resource "kubernetes_persistent_volume" "k8s-pv" {
  metadata {
    name = "k8s-pv"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteOnce"]

    persistent_volume_source {
      azure_disk {
        caching_mode  = "None"
        data_disk_uri = azurerm_managed_disk.k8s-disk.id
        disk_name     = "k8s"
        kind          = "Managed"
      }
      host_path {
        path = "/mnt/data"
      }
    }
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

resource "kubernetes_persistent_volume_claim" "k8s-pvc" {
  metadata {
    name = "k8s-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    storage_class_name = "standard"
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}


resource "azurerm_managed_disk" "k8s-disk" {
  name                 = "k8s-disk"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
  tags = {
    environment = azurerm_resource_group.rg.name
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}