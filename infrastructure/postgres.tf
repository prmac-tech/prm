
resource "helm_release" "postgresql" {
  name             = "postgres"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "postgresql-ha"
  version          = "14.3.7"
  namespace        = "prm"
  create_namespace = true

  set {
    name  = "pgpool.replicaCount"
    value = var.postgresql_router_count
  }

  set {
    name  = "postgresql.replicaCount"
    value = var.postgresql_server_count
  }

  set {
    name  = "postgresqlImage.tag"
    value = var.postgresql_version
  }

  set {
    name  = "persistence.size"
    value = var.kubernetes_storage_allocation_size
  }

  #-------------------------------------------------------------------------------------------------
  # Authentication
  #-------------------------------------------------------------------------------------------------
  set_sensitive {
    name  = "global.pgpool.adminUsername"
    value = var.postgresql_username
  }

  set_sensitive {
    name  = "global.pgpool.adminPassword"
    value = var.postgresql_password
  }

  set_sensitive {
    name  = "postgresql.password"
    value = var.postgresql_password
  }

  set_sensitive {
    name  = "postgresql.repmgrPassword"
    value = "var.postgresql_password"
  }

  set_sensitive {
    name  = "postgresql.repmgrUsername"
    value = "repmgr"
  }

  set_sensitive {
    name  = "pgpool.adminPassword"
    value = var.postgresql_password
  }

  #-------------------------------------------------------------------------------------------------
  # Common
  #-------------------------------------------------------------------------------------------------
  set {
    name  = "fullnameOverride"
    value = "prm-postgres"
  }

  set {
    name  = "pgpoolImage.tag"
    value = "latest"
  }

  set {
    name  = "volumePermissions.enabled"
    value = true
  }

  set {
    name  = "volumePermissionsImage.tag"
    value = "10"
  }

  set {
    name  = "persistence.existingClaim"
    value = var.kubernetes_storage_pvc
  }

  depends_on = [
    kubernetes_persistent_volume_claim.prm-pvc
  ]

}
