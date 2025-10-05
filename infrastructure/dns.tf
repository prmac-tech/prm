data "azurerm_subscription" "current" {}

data "azurerm_dns_zone" "aks_dns_zone" {
  name                = "pr-mac.com"
}

resource "azurerm_user_assigned_identity" "aks_dns_identity" {
  name                = "aks-dns-identity"
  resource_group_name = "prm"
  location            = data.azurerm_resource_group.rg.location

}

resource "azurerm_federated_identity_credential" "default" {
  name                = "prm"
  resource_group_name = "prm"
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aks_dns_identity.id
  subject             = "system:serviceaccount:prm:external-dns"

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

resource "azurerm_role_assignment" "aks_dns_role_assignment" {
  scope                = data.azurerm_dns_zone.aks_dns_zone.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_dns_identity.principal_id
}

resource "azurerm_role_assignment" "aks_rg_reader_role_assignment" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.aks_dns_identity.principal_id
}

resource helm_release ingress {
  name       = "ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "prm"
  version    = "4.11.3"
  wait       = false

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }

  set {
    name = "tcp.5432"
    value = "prm/prm-postgres-postgresql:5432"
  }

  depends_on = [
    helm_release.cert_manager,
    azurerm_kubernetes_cluster.aks
  ]
}


resource helm_release external_dns {
  name       = "external-dns"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "external-dns"
  namespace  = "prm"
  version    = "8.9.2"

  set {
    name  = "image.repository"
    value = "docker.io/bitnamilegacy"
  }

  set {
    name  = "global.security.allowInsecureImages"
    value = "true"
  }

  values = [
    templatefile("${path.root}/ext-dns/values.yaml", {
      azure_subscription_id  = data.azurerm_subscription.current.subscription_id
      azure_tenant_id        = data.azurerm_subscription.current.tenant_id
      external_dns_client_id = azurerm_user_assigned_identity.aks_dns_identity.client_id
      azure_resource_group   = "prm"
    })
  ]

  depends_on = [
    azurerm_user_assigned_identity.aks_dns_identity,
    azurerm_kubernetes_cluster.aks
  ]
}