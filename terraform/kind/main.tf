resource "kind_cluster" "dev" {
  name = var.cluster_name
  node_image = "kindest/node:v1.29.1"

  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
    }

    node {
      role = "worker"

      extra_port_mappings {
        container_port = 30000
        host_port      = 80
        listen_address = "127.0.0.1"
        protocol       = "TCP"
      }

      extra_port_mappings {
        container_port = 31000
        host_port      = 443
        listen_address = "127.0.0.1"
        protocol       = "TCP"
      }

      extra_port_mappings {
        container_port = 32000
        host_port      = 15021
        listen_address = "127.0.0.1"
        protocol       = "TCP"
      }
    }

    node {
      role = "worker"
    }
  }
}