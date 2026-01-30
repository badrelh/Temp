resource "kubernetes_stateful_set" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.database.metadata[0].name
    
    labels = {
      app        = "mysql"
      tier       = "database"
      managed_by = "terraform"
    }
  }

  spec {
    service_name = "mysql"
    replicas     = 1
    
    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app  = "mysql"
          tier = "database"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:8.0"

          port {
            container_port = 3306
            name           = "mysql"
          }

          # Montage des secrets pour credentials
          env_from {
            secret_ref {
              name = kubernetes_secret.mysql_credentials.metadata[0].name
            }
          }

          # Montage du PVC pour persistance
          volume_mount {
            name       = "mysql-data"
            mount_path = "/var/lib/mysql"
          }

          # Montage du ConfigMap pour init.sql
          volume_mount {
            name       = "mysql-init"
            mount_path = "/docker-entrypoint-initdb.d"
          }

          # Readiness probe pour attendre que MySQL soit prêt
          readiness_probe {
            exec {
              command = ["mysql", "-u", "root", "-p${var.mysql_root_password}", "-e", "SELECT 1"]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          # Liveness probe pour redémarrer si MySQL crashe
          liveness_probe {
            tcp_socket {
              port = 3306
            }
            initial_delay_seconds = 45
            period_seconds        = 20
          }
        }

        # Volume pour le ConfigMap
        volume {
          name = "mysql-init"
          config_map {
            name = kubernetes_config_map.mysql_init.metadata[0].name
          }
        }
      }
    }

    # Claim template pour le PVC
    volume_claim_template {
      metadata {
        name = "mysql-data"
      }

      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "standard"

        resources {
          requests = {
            storage = "5Gi"
          }
        }
      }
    }
  }
}

# Service ClusterIP pour MySQL (communication interne uniquement)
resource "kubernetes_service" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.database.metadata[0].name
    
    labels = {
      app = "mysql"
    }
  }

  spec {
    type = "ClusterIP"
    
    selector = {
      app = "mysql"
    }

    port {
      port        = 3306
      target_port = 3306
      protocol    = "TCP"
    }

    cluster_ip = "None"  # Headless service pour StatefulSet
  }
}

output "mysql_service_fqdn" {
  value       = "${kubernetes_service.mysql.metadata[0].name}.${kubernetes_namespace.database.metadata[0].name}.svc.cluster.local"
  description = "FQDN complet pour accéder à MySQL depuis Flask"
}
