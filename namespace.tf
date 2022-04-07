resource "kubernetes_namespace" "cloudwatch" {
  count = var.create_cwagent || var.create_fluentd ? 1 : 0
  metadata {
    name = var.cloudwatch_namespace

    labels = {
      name = var.cloudwatch_namespace
    }
  }
}
