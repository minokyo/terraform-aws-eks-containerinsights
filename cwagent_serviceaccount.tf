resource "kubernetes_service_account" "cloudwatch_agent" {
  count = var.create_cwagent ? 1 : 0
  metadata {
    name      = var.cwagent_sa_name
    namespace = kubernetes_namespace.cloudwatch[0].metadata[0].name
  }
}

resource "kubernetes_cluster_role" "cloudwatch_agent_role" {
  count = var.create_cwagent ? 1 : 0
  metadata {
    name = var.cwagent_cr_name
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = [""]
    resources  = ["pods", "nodes", "endpoints"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["apps"]
    resources  = ["replicasets"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["batch"]
    resources  = ["jobs"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["nodes/proxy"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["nodes/stats", "configmaps", "events"]
  }

  rule {
    verbs          = ["get", "update"]
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["cwagent-clusterleader"]
  }
}

resource "kubernetes_cluster_role_binding" "cloudwatch_agent_role_binding" {
  count = var.create_cwagent ? 1 : 0
  metadata {
    name = var.cwagent_crb_name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cloudwatch_agent[0].metadata[0].name
    namespace = kubernetes_namespace.cloudwatch[0].metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cloudwatch_agent_role[0].metadata[0].name
  }
}
