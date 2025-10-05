resource "kubernetes_secret" "docker-registry" {
  metadata {
    name = "regcred"
    namespace = "prm"
  }

  data = {
    ".dockerconfigjson" = "${data.template_file.docker_config_script.rendered}"
  }

  type = "kubernetes.io/dockerconfigjson"

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    kubernetes_namespace.prm
  ]
}

resource "kubernetes_secret" "azure-config-file" {
  metadata {
    name = "azure-config-file"
    namespace = "prm"
  }
  data = {
    "azure-config-file" = "${data.template_file.docker_config_script.rendered}"
  }
  type = "Opaque"
  depends_on = [
    azurerm_kubernetes_cluster.aks,
    kubernetes_namespace.prm,
    data.template_file.azure-config-file
  ]
}

data "template_file" "azure-config-file" {
#  azure_subscription_id  = data.azurerm_subscription.current.subscription_id
#  azure_tenant_id        = data.azurerm_subscription.current.tenant_id
#  external_dns_client_id = azurerm_user_assigned_identity.aks_dns_identity.client_id
  template = "${file("azure-config-file.json")}"
  vars = {
    tenantId           = data.azurerm_subscription.current.tenant_id
    subscriptionId     = data.azurerm_subscription.current.subscription_id
    resourceGroup      = "prm"
    aadClientId        = azurerm_user_assigned_identity.aks_dns_identity.client_id
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    kubernetes_namespace.prm,
    azurerm_user_assigned_identity.aks_dns_identity
  ]
}


data "template_file" "docker_config_script" {
  template = "${file("config.json")}"
  vars = {
    docker-username           = "${var.docker_username}"
    docker-password           = "${var.docker_password}"
    docker-server             = "${var.docker_server}"
    docker-email              = "${var.docker_email}"
    auth                      = base64encode("${var.docker_username}:${var.docker_password}")
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    kubernetes_namespace.prm
  ]
}