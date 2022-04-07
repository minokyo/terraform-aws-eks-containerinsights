resource "kubernetes_daemonset" "fluentd_cloudwatch" {
  count = var.create_fluentd ? 1 : 0
  metadata {
    name      = "fluentd-cloudwatch"
    namespace = kubernetes_namespace.cloudwatch[0].metadata[0].name
  }

  spec {
    selector {
      match_labels = {
        k8s-app = "fluentd-cloudwatch"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "fluentd-cloudwatch"
        }

        annotations = {
          configHash = "8915de4cf9c3551a8dc74c0137a3e83569d28c71044b0359c2578d2e0461825"
        }
      }

      spec {
        volume {
          name = "config-volume"

          config_map {
            name = kubernetes_config_map.fluentd_config[0].metadata[0].name
          }
        }

        volume {
          name = "fluentdconf"
          empty_dir {}
        }

        volume {
          name = "varlog"

          host_path {
            path = "/var/log"
          }
        }

        volume {
          name = "varlibdockercontainers"

          host_path {
            path = "/var/lib/docker/containers"
          }
        }

        volume {
          name = "runlogjournal"

          host_path {
            path = "/run/log/journal"
          }
        }

        volume {
          name = "dmesg"

          host_path {
            path = "/var/log/dmesg"
          }
        }

        init_container {
          name    = "copy-fluentd-config"
          image   = "busybox"
          command = ["sh", "-c", "cp /config-volume/..data/* /fluentd/etc"]

          volume_mount {
            name       = "config-volume"
            mount_path = "/config-volume"
          }

          volume_mount {
            name       = "fluentdconf"
            mount_path = "/fluentd/etc"
          }
        }

        init_container {
          name    = "update-log-driver"
          image   = var.fluentd_init_image
          command = ["sh", "-c", ""]
        }

        container {
          name  = "fluentd-cloudwatch"
          image = var.fluentd_image

          env {
            name = "AWS_REGION"

            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.cluster_info[0].metadata[0].name
                key  = "logs.region"
              }
            }
          }

          env {
            name = "CLUSTER_NAME"

            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.cluster_info[0].metadata[0].name
                key  = "cluster.name"
              }
            }
          }

          env {
            name  = "CI_VERSION"
            value = "k8s/1.2.4"
          }

          resources {
            limits = {
              memory = "400Mi"
            }

            requests = {
              cpu    = "100m"
              memory = "200Mi"
            }
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/config-volume"
          }

          volume_mount {
            name       = "fluentdconf"
            mount_path = "/fluentd/etc"
          }

          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
          }

          volume_mount {
            name       = "varlibdockercontainers"
            read_only  = true
            mount_path = "/var/lib/docker/containers"
          }

          volume_mount {
            name       = "runlogjournal"
            read_only  = true
            mount_path = "/run/log/journal"
          }

          volume_mount {
            name       = "dmesg"
            read_only  = true
            mount_path = "/var/log/dmesg"
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = kubernetes_service_account.fluentd[0].metadata[0].name
        automount_service_account_token  = true
      }
    }
  }
}
