provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "java_app" {
  metadata {
    name = "java-app"
  }
}

resource "kubernetes_deployment" "java_app" {
  metadata {
    name      = "java-app"
    namespace = kubernetes_namespace.java_app.metadata[0].name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "java-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "java-app"
        }
      }
      spec {
        container {
          image = "merajansari87/java-demo:latest"
          name  = "java-app"
          port {
            container_port = 8090
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "java_app" {
  metadata {
    name      = "java-app"
    namespace = kubernetes_namespace.java_app.metadata[0].name
  }
  spec {
    selector = {
      app = "java-app"
    }
    port {
      port        = 80
      target_port = 8090
    }
    type = "NodePort"
  }
}
