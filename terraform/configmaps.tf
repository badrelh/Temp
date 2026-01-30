resource "kubernetes_config_map" "mysql_init" {
  metadata {
    name      = "mysql-init-script"
    namespace = kubernetes_namespace.database.metadata[0].name
    
    labels = {
      app        = "movies-interface"
      component  = "database-init"
      managed_by = "terraform"
    }
  }

  data = {
    "init.sql" = file("${path.module}/../init.sql")
  }
}

output "mysql_init_configmap" {
  value       = kubernetes_config_map.mysql_init.metadata[0].name
  description = "ConfigMap contenant le script init.sql"
}
