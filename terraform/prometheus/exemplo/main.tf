resource "kubernetes_secret" "thanos_objstore" {
  metadata {
    name      = "thanos-objstore-config"
    namespace = var.namespace
  }

  data = {
    # Configuração usada pelo Sidecar do Thanos para envio ao bucket
    "objstore.yml" = yamlencode({
      type = "S3"
      config = {
        bucket             = var.thanos_bucket
        region             = var.thanos_region
        endpoint           = var.thanos_endpoint
        insecure           = var.thanos_insecure
        signature_version2 = false
      }
    })
  }

  type = "Opaque"
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  namespace        = var.namespace
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = var.promethues_version
  create_namespace = true
  wait             = true
  timeout          = 1800

  # ⚠️ CRDs desativados para permitir dual running. Após migração, ativar.
  skip_crds = false

  depends_on = [kubernetes_secret.thanos_objstore]

  set {
    name  = "prometheus.thanosService.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.thanosServiceMonitor.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.prometheusSpec.thanos.image"
    value = "quay.io/thanos/thanos:${var.thanos_version}"
  }

  set {
    name  = "prometheus.prometheusSpec.thanos.objectStorageConfig.existingSecret.name"
    value = kubernetes_secret.thanos_objstore.metadata[0].name
  }

  set {
    name  = "prometheus.prometheusSpec.thanos.objectStorageConfig.existingSecret.key"
    value = "objstore.yml"
  }

  set {
    name  = "prometheus.prometheusSpec.externalLabels.cluster"
    value = var.cluster_name
  }

  values = [
    yamlencode({
      crds = {
        enabled = false # ✅ Altere para `true` após fim do dual running
      }

      prometheus = {
        prometheusSpec = {
          replicas           = 2
          retention          = "24h"        # Curta retenção local
          retentionSize      = "2Gi"
          enableAdminAPI     = true
          scrapeInterval     = "30s"
          evaluationInterval = "30s"

          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = var.efs_enabled ? "efs-sc" : "gp2"
                accessModes      = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = "8Gi" # 💡 Suficiente para retenção curta
                  }
                }
              }
            }
          }

          podMetadata = {
            labels = {
              thanos-store-api = "true"
            }
          }

          resources = {
            requests = {
              cpu    = "100m"
              memory = "1Gi"
            }
          }
        }
      }

      prometheusOperator = {
        nodeSelector = {
          Worker = "infra"
        }
        tolerations = [{
          key      = "dedicated"
          operator = "Equal"
          value    = "infra"
          effect   = "NoSchedule"
        }]
        resources = {
          requests = {
            cpu    = "100m"
            memory = "256Mi"
          }
        }
      }

      kubeStateMetrics = {
        nodeSelector = {
          Worker = "infra"
        }
        tolerations = [{
          key      = "dedicated"
          operator = "Equal"
          value    = "infra"
          effect   = "NoSchedule"
        }]
      }

      "kube-state-metrics" = {
        collectors = [
          "certificatesigningrequests",
          "configmaps",
          "cronjobs",
          "daemonsets",
          "deployments",
          "endpoints",
          "horizontalpodautoscalers",
          "ingresses",
          "jobs",
          "leases",
          "limitranges",
          "mutatingwebhookconfigurations",
          "namespaces",
          "networkpolicies",
          "nodes",
          "persistentvolumeclaims",
          "persistentvolumes",
          "poddisruptionbudgets",
          "pods",
          "replicasets",
          "replicationcontrollers",
          "resourcequotas",
          "secrets",
          "services",
          "statefulsets",
          "storageclasses",
          "validatingwebhookconfigurations",
          "volumeattachments"
        ]
      }
    })
  ]
}
