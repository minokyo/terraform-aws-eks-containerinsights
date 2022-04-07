resource "kubernetes_config_map" "cluster_info" {
  count = var.create_fluentd ? 1 : 0
  metadata {
    name      = "cluster-info"
    namespace = kubernetes_namespace.cloudwatch[0].metadata[0].name
  }

  data = {
    "cluster.name" = var.k8s_cluster_name

    "logs.region" = var.region
  }
}

resource "kubernetes_config_map" "fluentd_config" {
  count = var.create_fluentd ? 1 : 0
  metadata {
    name      = "fluentd-config"
    namespace = kubernetes_namespace.cloudwatch[0].metadata[0].name

    labels = {
      k8s-app = "fluentd-cloudwatch"
    }
  }

  data = {
    "containers.conf" = templatefile("${path.module}/templates/fluentd_containers.conf.tpl", {})

    "fluent.conf" = templatefile("${path.module}/templates/fluentd_fluent.conf.tpl", {})

    "host.conf" = templatefile("${path.module}/templates/fluentd_host.conf.tpl", {}) 

    "systemd.conf" = templatefile("${path.module}/templates/fluentd_systemd.conf.tpl", {}) 
  }
}
