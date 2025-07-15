variable "nfs_server_path" {
  description = "Caminho local no host do NFS server"
  type        = string
  default     = "/home/ubuntu/nfs"
}
variable "kubeconfig_path" {
  description = "Caminho para o kubeconfig local"
  type        = string
  default     = "~/.kube/config"
}