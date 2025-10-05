
resource "helm_release" "keycloak" {
  name       = "auth"
  repository = "https://airbytehq.github.io/helm-charts"
  chart      = "keycloak"
  namespace  = "prm"
  version    = "2.0.0"
  timeout    = "600"

  values = [
    templatefile("${path.root}/auth/values.yaml", {
      admin_password  = "test"
      postgres_password = var.postgresql_password
    })
  ]

#  set {
#    name  = "image.repository"
#    value = "bitnamilegacy"
#  }
#
#  set {
#    name  = "global.security.allowInsecureImages"
#    value = "true"
#  }

  depends_on = [
    kubectl_manifest.certificates,
    azurerm_kubernetes_cluster.aks,
    helm_release.keycloak
  ]
}
