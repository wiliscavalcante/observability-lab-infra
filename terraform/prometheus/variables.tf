variable "namespace" {
  description = "Namespace de observabilidade"
  type        = string
  default     = "observability"
}

variable "thanos_bucket" {
  type    = string
  default = "thanos-lab-kind"
}

variable "thanos_endpoint" {
  type    = string
  default = "minio.observability.svc.cluster.local:9000"
}

variable "thanos_access_key" {
  type    = string
  default = "amjsJcYygzzajLES136m"
}

variable "thanos_secret_key" {
  type    = string
  default = "YiSTwHEYxIOZ9II3SuQjcYt17nChZXL2TcIJKt57"
}
variable "kubeconfig_path" {
  description = "Caminho para o kubeconfig local"
  type        = string
  default     = "~/.kube/config"
}
variable "prometheus_release_name" {
  type    = string
  default = "prometheus"
}