resource "kubernetes_namespace" "istio" {
  metadata {
    name = var.istio_namespace
  }
}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = var.istio_namespace
  version    = var.istio_version
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = var.istio_namespace
  version    = var.istio_version

  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_gateway" {
  name       = var.istio_gateway_name
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = var.istio_namespace
  version    = var.istio_version

  depends_on = [helm_release.istiod]

  values = [
    yamlencode({
      service = {
        type = "NodePort"
        ports = [
          {
            name       = "http2"
            port       = 80
            nodePort   = 30000
          },
          {
            name       = "https"
            port       = 443
            nodePort   = 31000
          },
          {
            name       = "status-port"
            port       = 15021
            targetPort = 15021
            nodePort   = 32000
          }
        ]
      }
    })
  ]
}
