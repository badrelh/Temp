resource "kubernetes_namespace" "flask_app" {
  metadata {
    name = "flask-app"
    
    labels = {
      app         = "movies-interface"
      tier        = "frontend"
      managed_by  = "terraform"
      environment = "dev"
    }
  }
}

resource "kubernetes_namespace" "database" {
  metadata {
    name = "database"
    
    labels = {
      app         = "movies-interface"
      tier        = "data"
      managed_by  = "terraform"
      environment = "dev"
    }
  }
}

# Outputs pour vérification
output "flask_namespace" {
  value = kubernetes_namespace.flask_app.metadata[0].name
}

output "database_namespace" {
  value = kubernetes_namespace.database.metadata[0].name
}
