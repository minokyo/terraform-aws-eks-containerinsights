resource "kubernetes_service_account" "fluentd" {
  count = var.create_fluentd ? 1 : 0
  metadata {
    name      = var.fluentd_sa_name
    namespace = kubernetes_namespace.cloudwatch[0].metadata[0].name
  }
}

resource "kubernetes_cluster_role" "fluentd_role" {
  count = var.create_fluentd ? 1 : 0
  metadata {
    name = var.fluentd_cr_name
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["namespaces", "pods", "pods/logs"]
  }
}

resource "kubernetes_cluster_role_binding" "fluentd_role_binding" {
  count = var.create_fluentd ? 1 : 0
  metadata {
    name = var.fluentd_crb_name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.fluentd[0].metadata[0].name
    namespace = kubernetes_namespace.cloudwatch[0].metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.fluentd_role[0].metadata[0].name
  }
}
