# create namespace for cert mananger
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    labels = {
      "name" = "cert-manager"
    }
    name = "cert-manager"
  }
}

# Install cert-manager helm chart using terraform
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.12.3"
  namespace  = kubernetes_namespace.cert_manager.metadata.0.name
  set {
    name  = "installCRDs"
    value = "true"
  }
  depends_on = [
    kubernetes_namespace.cert_manager
  ]
}

locals {
  clusterissuer = "certificate-manager/clusterissuer-nginx.yaml"
}

# Create clusterissuer for nginx YAML file
data "kubectl_file_documents" "clusterissuer" {
  content = file(local.clusterissuer)
}

# Apply clusterissuer for nginx YAML file
resource "kubectl_manifest" "clusterissuer" {
  for_each  = data.kubectl_file_documents.clusterissuer.manifests
  yaml_body = each.value
  depends_on = [
    data.kubectl_file_documents.clusterissuer
  ]
}