variable "kubeconfig_path" {
  description = "Caminho para o kubeconfig local"
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "observability"
}

variable "minio_release_name" {
  type        = string
  default     = "minio"
  description = "Nome da release do Helm para o MinIO"
}

variable "minio_access_key" {
  type        = string
  default     = "minioadmin"
  sensitive   = true
}

variable "minio_secret_key" {
  type        = string
  default     = "minioadmin"
  sensitive   = true
}
