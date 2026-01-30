resource "kubernetes_secret" "mysql_credentials" {
  metadata {
    name      = "mysql-credentials"
    namespace = kubernetes_namespace.database.metadata[0].name
  }

  data = {
    MYSQL_ROOT_PASSWORD = var.mysql_root_password
    MYSQL_USER          = "movies_user"
    MYSQL_PASSWORD      = var.mysql_password
    MYSQL_DATABASE      = "movies_db"
  }

  type = "Opaque"
}

resource "kubernetes_secret" "flask_config" {
  metadata {
    name      = "flask-config"
    namespace = kubernetes_namespace.flask_app.metadata[0].name
  }

  data = {
    SECRET_KEY   = var.flask_secret_key
    DATABASE_URL = "mysql+pymysql://movies_user:${var.mysql_password}@mysql.database.svc.cluster.local/movies_db"
  }

  type = "Opaque"
}

output "mysql_secret_name" {
  value       = kubernetes_secret.mysql_credentials.metadata[0].name
  description = "Nom du Secret MySQL"
}

output "flask_secret_name" {
  value       = kubernetes_secret.flask_config.metadata[0].name
  description = "Nom du Secret Flask"
}
