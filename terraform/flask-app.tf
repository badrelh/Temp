resource "kubernetes_deployment" "flask" {
  metadata {
    name      = "movies-interface"
    namespace = kubernetes_namespace.flask_app.metadata[0].name
    
    labels = {
      app        = "movies-interface"
      tier       = "frontend"
      managed_by = "terraform"
    }
  }

  spec {
    replicas = 2  # 2 réplicas pour haute disponibilité

    selector {
      match_labels = {
        app  = "movies-interface"
        tier = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app  = "movies-interface"
          tier = "frontend"
        }
      }

      spec {
        # Attendre que MySQL soit prêt avant de démarrer Flask
        init_container {
          name  = "wait-for-mysql"
          image = "busybox:1.35"
          
          command = [
            "sh",
            "-c",
            "until nc -z mysql.database.svc.cluster.local 3306; do echo waiting for mysql; sleep 2; done"
          ]
        }

        container {
          name  = "flask"
          image = "badruser/movies-interface:1.0.0"  # Remplacer par votre image

          image_pull_policy = "Never"

          port {
            container_port = 5000
            name           = "http"
          }

          # Variables d'environnement depuis les secrets
          env_from {
            secret_ref {
              name = kubernetes_secret.flask_config.metadata[0].name
            }
          }

          # Variables d'environnement additionnelles
          env {
            name  = "FLASK_ENV"
            value = "production"
          }

          env {
            name  = "MYSQL_HOST"
            value = "mysql.database.svc.cluster.local"
          }

          env {
            name  = "MYSQL_USER"
            value = "movies_user"
          }

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_credentials.metadata[0].name
                key  = "MYSQL_PASSWORD"
              }
            }
          }

          env {
            name  = "MYSQL_DATABASE"
            value = "movies_db"
          }

          # Readiness probe pour vérifier que Flask répond
          readiness_probe {
            http_get {
              path = "/"
              port = 5000
            }
            initial_delay_seconds = 10
            period_seconds        = 5
          }

          # Liveness probe
          liveness_probe {
            http_get {
              path = "/"
              port = 5000
            }
            initial_delay_seconds = 15
            period_seconds        = 10
          }

          # Ressources limitées (bonne pratique)
          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
}

# Service NodePort pour accès externe
resource "kubernetes_service" "flask" {
  metadata {
    name      = "movies-interface-svc"
    namespace = kubernetes_namespace.flask_app.metadata[0].name
    
    labels = {
      app = "movies-interface"
    }
  }

  spec {
    type = "NodePort"
    
    selector = {
      app  = "movies-interface"
      tier = "frontend"
    }

    port {
      port        = 80
      target_port = 5000
      node_port   = 30500  # Port accessible via Minikube
      protocol    = "TCP"
    }
  }
}

output "flask_service_url" {
  value       = "http://$(minikube ip):30500"
  description = "URL pour accéder à Movies-Interface"
}

output "flask_replicas" {
  value       = kubernetes_deployment.flask.spec[0].replicas
  description = "Nombre de réplicas Flask"
}
