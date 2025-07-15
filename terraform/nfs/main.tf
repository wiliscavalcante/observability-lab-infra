resource "helm_release" "nfs_server" {
  name       = "nfs-server"
  namespace  = "observability"
  repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner"
  chart      = "nfs-subdir-external-provisioner"
  version    = "4.0.18"

  values = [
    file("${path.module}/values.yaml")
  ]
}
