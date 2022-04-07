locals {
  cwagentconfig_var = {
    region                      = var.region
    cluster_name                = var.k8s_cluster_name
    force_flush_interval        = var.cwagent_force_flush_interval
    metrics_collection_interval = var.cwagent_metrics_collection_interval
  }
}

resource "kubernetes_config_map" "cwagentconfig" {
  count = var.create_cwagent ? 1 : 0
  metadata {
    name      = "cwagentconfig"
    namespace = kubernetes_namespace.cloudwatch[0].metadata[0].name
  }

  data = {
    "cwagentconfig.json" = templatefile("${path.module}/templates/cwagentconfig.json.tpl", local.cwagentconfig_var)
  }
}
