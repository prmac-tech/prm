
resource "helm_release" "postgresql" {
  name             = "postgres"
#    repository       = "oci://registry-1.docker.io/bitnamicharts"
  #  repository       = "https://cloudnative-pg.io/charts/cloudnative-pg"
  chart            = "${path.module}/../helm/charts/helm_charts/postgresql-ha"
  version          = "1.0.0"
  namespace        = "prm"
  create_namespace = true

  set {
    name  = "postgresql.initContainers"
    value = [
      <<EOT
      pgupgrade:
        env:
          - name: PGAUTO_ONESHOT
            value: "yes"
          - name: PGDATA
            value: /bitnami/postgresql/data
          - name: POSTGRES_PASSWORD
            value: ${var.postgresql_password.value}
        image: pgautoupgrade/pgautoupgrade:18-trixie
        name: upgrade-postgres
        securityContext:
          runAsUser: 0
        volumeMounts:
          - mountPath: /bitnami/postgresql
            name: prm
    EOT
    ]
    }
#  }
#
#  set {
#    name  = "global.security.allowInsecureImages"
#    value = "true"
#

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
    value = var.postgresql_password
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

resource "kubernetes_config_map" "postgres_config" {
  metadata {
    name = "postgres-config"
    namespace = "prm"
  }
  data = {
    5432 = "prm/prm-postgres-postgresql:5432"
  }
}


resource "kubernetes_ingress_v1" "postgres_ingress" {
  metadata {
    name        = "postgres-ingress"
    namespace   = "prm"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "postgres.pr-mac.com"
      http {
        path {
            backend {
              service {
                name = "prm-postgres-postgresql"
                port {
                  number = 5432
                }
              }
            }
            path = "/"
          }
        }
    }
    tls {
      secret_name = "postgres-service-cert"
    }
  }
}