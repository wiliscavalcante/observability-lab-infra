resource "helm_release" "minio" {
  name       = var.minio_release_name
  namespace  = var.namespace
  repository = "https://charts.min.io/"
  chart      = "minio"
  version    = "5.4.0"

  create_namespace = true

  values = [
    yamlencode({
      mode = "standalone"
      persistence = {
        enabled      = true
        size         = "10Gi"
        storageClass = "standard"
      }

      resources = {
        requests = {
          memory = "512Mi"
          cpu    = "250m"
        }
        limits = {
          memory = "1Gi"
          cpu    = "500m"
        }
      }

      service = {
        type = "ClusterIP"
        ports = {
          api     = 9000
          console = 9001
        }
      }

      rootUser     = var.minio_access_key
      rootPassword = var.minio_secret_key
    })
  ]
}

resource "kubernetes_manifest" "minio_gateway" {
  depends_on = [helm_release.minio]

  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "Gateway"
    metadata = {
      name      = "minio-gateway"
      namespace = var.namespace
    }
    spec = {
      selector = {
        istio = "gateway"
      }
      servers = [
        {
          port = {
            number   = 80
            name     = "http"
            protocol = "HTTP"
          }
          hosts = ["minio.local", "minio-console.local"]
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "minio_console_vs" {
  depends_on = [helm_release.minio]

  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "VirtualService"
    metadata = {
      name      = "minio-console-vs"
      namespace = var.namespace
    }
    spec = {
      hosts    = ["minio-console.local"]
      gateways = ["minio-gateway"]
      http     = [
        {
          match = [{ uri = { prefix = "/" } }]
          route = [
            {
              destination = {
                host = "minio-console.${var.namespace}.svc.cluster.local"
                port = { number = 9001 }
              }
            }
          ]
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "minio_api_vs" {
  depends_on = [helm_release.minio]

  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "VirtualService"
    metadata = {
      name      = "minio-api-vs"
      namespace = var.namespace
    }
    spec = {
      hosts    = ["minio.local"]
      gateways = ["minio-gateway"]
      http     = [
        {
          match = [{ uri = { prefix = "/" } }]
          route = [
            {
              destination = {
                host = "minio.${var.namespace}.svc.cluster.local"
                port = { number = 9000 }
              }
            }
          ]
        }
      ]
    }
  }
}
