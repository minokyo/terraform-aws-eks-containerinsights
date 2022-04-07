resource "kubernetes_daemonset" "cloudwatch_agent" {
  count = var.create_cwagent ? 1 : 0
  metadata {
    name      = kubernetes_service_account.cloudwatch_agent[0].metadata[0].name
    namespace = kubernetes_namespace.cloudwatch[0].metadata[0].name
  }

  spec {
    selector {
      match_labels = {
        name = kubernetes_service_account.cloudwatch_agent[0].metadata[0].name
      }
    }

    template {
      metadata {
        labels = {
          name = kubernetes_service_account.cloudwatch_agent[0].metadata[0].name
        }
      }

      spec {
        volume {
          name = "cwagentconfig"

          config_map {
            name = kubernetes_config_map.cwagentconfig[0].metadata[0].name
          }
        }

        volume {
          name = "rootfs"

          host_path {
            path = "/"
          }
        }

        volume {
          name = "dockersock"

          host_path {
            path = "/var/run/docker.sock"
          }
        }

        volume {
          name = "varlibdocker"

          host_path {
            path = "/var/lib/docker"
          }
        }

        volume {
          name = "sys"

          host_path {
            path = "/sys"
          }
        }

        volume {
          name = "devdisk"

          host_path {
            path = "/dev/disk/"
          }
        }

        container {
          name  = kubernetes_service_account.cloudwatch_agent[0].metadata[0].name
          image = var.cwagent_image

          env {
            name = "HOST_IP"

            value_from {
              field_ref {
                field_path = "status.hostIP"
              }
            }
          }

          env {
            name = "HOST_NAME"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name = "K8S_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name  = "CI_VERSION"
            value = "k8s/1.2.4"
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "200Mi"
            }

            requests = {
              cpu    = "200m"
              memory = "200Mi"
            }
          }

          volume_mount {
            name       = "cwagentconfig"
            mount_path = "/etc/cwagentconfig"
          }

          volume_mount {
            name       = "rootfs"
            read_only  = true
            mount_path = "/rootfs"
          }

          volume_mount {
            name       = "dockersock"
            read_only  = true
            mount_path = "/var/run/docker.sock"
          }

          volume_mount {
            name       = "varlibdocker"
            read_only  = true
            mount_path = "/var/lib/docker"
          }

          volume_mount {
            name       = "sys"
            read_only  = true
            mount_path = "/sys"
          }

          volume_mount {
            name       = "devdisk"
            read_only  = true
            mount_path = "/dev/disk"
          }
        }

        termination_grace_period_seconds = 60
        service_account_name             = kubernetes_service_account.cloudwatch_agent[0].metadata[0].name
        automount_service_account_token  = true
      }
    }
  }
}
