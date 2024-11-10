#resource "kubernetes_persistent_volume_claim" "k8s-pvc" {
#  metadata {
#    name = "k8s-pvc"
#    namespace  = "prm"
#  }
#  spec {
#    access_modes = ["ReadWriteOnce"]
#    resources {
#      requests = {
#        storage = "1Gi"
#      }
#    }
#    storage_class_name = "default"
#  }
#  depends_on = [
#    azurerm_kubernetes_cluster.aks
#  ]
#}
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