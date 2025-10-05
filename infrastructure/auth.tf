
resource "helm_release" "keycloak" {
  name       = "auth"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "keycloak"
  namespace  = "prm"
  version    = "25.2.0"
  timeout    = "600"

  values = [
    templatefile("${path.root}/auth/values.yaml", {
      admin_password  = "test"
      postgres_password = var.postgresql_password
    })
  ]

  set {
    name  = "image.repository"
    value = "docker.io/bitnamilegacy"
  }

  depends_on = [
    kubectl_manifest.certificates,
    azurerm_kubernetes_cluster.aks,
    helm_release.keycloak
  ]
}
