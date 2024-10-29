# create namespace for cert mananger
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    labels = {
      "name" = "cert-manager"
    }
    name = "cert-manager"
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
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
  certificates = "certificate-manager/certificates.yaml"
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

data "kubectl_file_documents" "certificates" {
  content = file(local.certificates)
}

resource "kubectl_manifest" "certificates" {
  for_each  = data.kubectl_file_documents.certificates.manifests
  yaml_body = each.value
  depends_on = [
    kubernetes_namespace.prm,
    data.kubectl_file_documents.certificates
  ]
}