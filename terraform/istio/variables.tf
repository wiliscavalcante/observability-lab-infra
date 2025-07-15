variable "kubeconfig_path" {
  description = "Caminho para o kubeconfig local"
  type        = string
  default     = "~/.kube/config"
}

variable "istio_namespace" {
  description = "Namespace onde o Istio será instalado"
  type        = string
  default     = "istio-system"
}

variable "istio_gateway_name" {
  description = "Nome do Istio Gateway"
  type        = string
  default     = "istio-gateway"
}

variable "istio_version" {
  description = "Versão do Istio a ser instalada"
  type        = string
  default     = "1.26.2"
}
