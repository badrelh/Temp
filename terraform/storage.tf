resource "kubernetes_persistent_volume_claim" "mysql_data" {
  metadata {
    name      = "mysql-pvc"
    namespace = kubernetes_namespace.database.metadata[0].name
    
    labels = {
      app        = "movies-interface"
      component  = "mysql-storage"
      managed_by = "terraform"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    
    storage_class_name = "standard"  # Classe par défaut de Minikube
  }

  wait_until_bound = false  # Pour éviter le timeout en environnement de dev
}

output "mysql_pvc_name" {
  value       = kubernetes_persistent_volume_claim.mysql_data.metadata[0].name
  description = "PVC pour le stockage MySQL"
}
