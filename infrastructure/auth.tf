
resource "helm_release" "keycloak" {
  name       = "auth"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  namespace  = "prm"
  version    = "26.3.5"
  timeout    = "600"

  values = [
    templatefile("${path.root}/auth/values.yaml", {
      admin_password  = "test"
      postgres_password = var.postgresql_password
    })
  ]
  depends_on = [
    kubectl_manifest.certificates,
    azurerm_kubernetes_cluster.aks,
    helm_release.keycloak
  ]
}
