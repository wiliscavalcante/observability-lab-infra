resource "kubernetes_secret" "thanos_objstore" {
  metadata {
    name      = "thanos-objstore-config"
    namespace = var.namespace
  }

  data = {
    "objstore.yml" = yamlencode({
      type = "S3"
      config = {
        bucket              = var.thanos_bucket
        endpoint            = var.thanos_endpoint
        access_key          = var.thanos_access_key
        secret_key          = var.thanos_secret_key
        insecure            = true
        signature_version2  = false
      }
    })
  }

  type = "Opaque"
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus"
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "75.10.0"

  values = [
    file("${path.module}/prometheus-values.yaml")
  ]

  depends_on = [kubernetes_secret.thanos_objstore]
}

resource "kubernetes_manifest" "prometheus_gateway" {
  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "Gateway"
    metadata = {
      name      = "prometheus-gateway"
      namespace = var.namespace
    }
    spec = {
      selector = {
        istio = "gateway"
      }
      servers = [{
        port = {
          number   = 80
          name     = "http"
          protocol = "HTTP"
        }
        hosts = ["prometheus.local"]
      }]
    }
  }
}

resource "kubernetes_manifest" "prometheus_virtualservice" {
  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "VirtualService"
    metadata = {
      name      = "prometheus-vs"
      namespace = var.namespace
    }
    spec = {
      hosts    = ["prometheus.local"]
      gateways = ["prometheus-gateway"]
      http     = [{
        match = [{ uri = { prefix = "/" } }]
        route = [{
          destination = {
            host = "kube-prometheus-kube-prome-prometheus.${var.namespace}.svc.cluster.local"
            port = { number = 9090 }
          }
        }]
      }]
    }
  }

  depends_on = [helm_release.kube_prometheus_stack]
}