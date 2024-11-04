
resource "helm_release" "keycloak" {
  name       = "auth"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  namespace  = "prm"
  version    = "24.0.2"

  values = [
    templatefile("${path.root}/auth/values.yaml", {
      admin_password  = "test"
    })
  ]
  depends_on = [
    kubernetes_persistent_volume_claim.k8s-pvc,
    kubectl_manifest.certificates,
    azurerm_kubernetes_cluster.aks
  ]
}
