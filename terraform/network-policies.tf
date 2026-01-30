# Deny-all par défaut dans flask-app namespace
resource "kubernetes_network_policy" "flask_deny_all" {
  metadata {
    name      = "deny-all-traffic"
    namespace = kubernetes_namespace.flask_app.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress", "Egress"]
  }
}

# Autoriser Flask à communiquer avec MySQL
resource "kubernetes_network_policy" "flask_to_mysql" {
  metadata {
    name      = "allow-flask-to-mysql"
    namespace = kubernetes_namespace.flask_app.metadata[0].name
  }

  spec {
    pod_selector {
      match_labels = {
        app = "movies-interface"
        tier = "frontend"
      }
    }

    egress {
      # Vers MySQL dans le namespace database
      to {
        namespace_selector {
          match_labels = {
            tier = "data"
          }
        }
        pod_selector {
          match_labels = {
            app = "mysql"
          }
        }
      }

      ports {
        protocol = "TCP"
        port     = "3306"
      }
    }

    # Autoriser DNS (nécessaire pour résoudre mysql.database.svc.cluster.local)
    egress {
      to {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "kube-system"
          }
        }
      }

      ports {
        protocol = "UDP"
        port     = "53"
      }
    }

    policy_types = ["Egress"]
  }
}

# Deny-all par défaut dans database namespace
resource "kubernetes_network_policy" "database_deny_all" {
  metadata {
    name      = "deny-all-traffic"
    namespace = kubernetes_namespace.database.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress", "Egress"]
  }
}

# MySQL accepte uniquement le trafic depuis Flask
resource "kubernetes_network_policy" "mysql_from_flask" {
  metadata {
    name      = "allow-from-flask-only"
    namespace = kubernetes_namespace.database.metadata[0].name
  }

  spec {
    pod_selector {
      match_labels = {
        app = "mysql"
      }
    }

    ingress {
      from {
        namespace_selector {
          match_labels = {
            tier = "frontend"
          }
        }
      }

      ports {
        protocol = "TCP"
        port     = "3306"
      }
    }

    policy_types = ["Ingress"]
  }
}

output "network_policies_created" {
  value = [
    kubernetes_network_policy.flask_deny_all.metadata[0].name,
    kubernetes_network_policy.flask_to_mysql.metadata[0].name,
    kubernetes_network_policy.database_deny_all.metadata[0].name,
    kubernetes_network_policy.mysql_from_flask.metadata[0].name
  ]
  description = "Network policies déployées"
}
