data azurerm_managed_disk azure_disk_prm {
  name = "prm"
  resource_group_name = "prmK8s"
}

resource "azurerm_role_assignment" "role-assignment" {
  role_definition_name = "Contributor"
  scope              = data.azurerm_managed_disk.azure_disk_prm
  principal_id       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

resource "kubernetes_persistent_volume" "pv-azuredisk" {
  metadata {
    annotations = { "pv.kubernetes.io/provisioned-by" = "disk.csi.azure.com"}
    name = "pv-azuredisk"
  }
  spec {
    capacity = {
      storage = "2Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "managed-csi"
    persistent_volume_source {
      azure_disk {
        caching_mode  = "None"
        data_disk_uri = data.azurerm_managed_disk.azure_disk_prm.id
        disk_name     = "prm"
        kind          = "Managed"
      }
    }
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

resource "kubernetes_persistent_volume_claim" "prm-pvc" {
  metadata {
    name = "prm"
    namespace  = "prm"
  }
  wait_until_bound = false
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "2Gi"
      }
    }
    storage_class_name = "managed-csi"
  }
  depends_on = [
    kubernetes_persistent_volume.pv-azuredisk
  ]
}
