resource "kubernetes_namespace" "prm" {
  metadata {
    labels = {
      "name" = "prm"
    }
    name = "prm"
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}