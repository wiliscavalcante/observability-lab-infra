variable "namespace" {
  type        = string
  description = "Namespace onde a stack será instalada"
  default     = "observability"
}

variable "promethues_version" {
  type        = string
  description = "Versão do kube-prometheus-stack"
}

variable "thanos_version" {
  type        = string
  description = "Versão do Thanos Sidecar (e demais componentes se aplicável)"
}

variable "thanos_bucket" {
  type        = string
  description = "Nome do bucket S3 para armazenamento do Thanos"
}

variable "thanos_region" {
  type        = string
  description = "Região do bucket S3"
}

variable "thanos_endpoint" {
  type        = string
  description = "Endpoint do S3 (ex: s3.amazonaws.com ou MinIO interno)"
}

variable "thanos_insecure" {
  type        = bool
  description = "Se o acesso ao endpoint do S3 é insecure (sem HTTPS)"
  default     = false
}

variable "cluster_name" {
  type        = string
  description = "Nome do cluster que será usado como external_label"
}

variable "efs_enabled" {
  type        = bool
  description = "Define se o EFS deve ser utilizado como StorageClass"
  default     = false
}
