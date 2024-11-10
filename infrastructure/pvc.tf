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