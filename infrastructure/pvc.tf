data azurerm_managed_disk azure_disk_prm {
  name = "prm"
  resource_group_name = "prm"
}

resource "kubernetes_persistent_volume" "pv-azuredisk" {
  metadata {
    annotations = "pv.kubernetes.io/provisioned-by: disk.csi.azure.com"
    name = "pv-azuredisk"
  }
  spec {
    capacity {
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
}

resource "kubernetes_persistent_volume_claim" "prm-pvc" {
  metadata {
    name = "prm"
    namespace  = "prm"
  }
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
    azurerm_kubernetes_cluster.aks
  ]
}
#apiVersion: v1
#kind: PersistentVolumeClaim
#metadata:
#name: azure-managed-disk
#spec:
#accessModes:
#- ReadWriteOnce
#storageClassName: managed-csi
#resources:
#requests:
#storage: 5Gi