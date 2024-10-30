
resource "helm_release" "keycloak" {
  name       = "cert-manager"
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
    azurerm_kubernetes_cluster.aks
  ]
}
