variable "k8s_cluster_name" {
  description = "Name of the kubernetes cluster."
  type        = string
}

variable "region" {
  description = "AWS region of the kubernetes cluster."
  type        = string
}

variable "create_cwagent" {
  description = "True to deploy Cloudwatch agent."
  type        = bool
  default     = true
}

variable "create_fluentd" {
  description = "True to deploy Fluentd."
  type        = bool
  default     = true
}

variable "cloudwatch_namespace" {
  description = "K8s namespace to deploy Cloudwatch Container Insights."
  type        = string
  default     = "amazon-cloudwatch"
}

variable "cwagent_sa_name" {
  description = "Service account name for Cloudwatch agent."
  type        = string
  default     = "cloudwatch-agent"
}

variable "cwagent_cr_name" {
  description = "Cluster Role name for Cloudwatch agent."
  type        = string
  default     = "cloudwatch-agent-role"
}

variable "cwagent_crb_name" {
  description = "Cluster Role Binding name for Cloudwatch agent."
  type        = string
  default     = "cloudwatch-agent-role-binding"
}

variable "cwagent_metrics_collection_interval" {
  description = "How often in seconds that the CloudWatch agent collects metrics."
  type        = number
  default     = 60
}

variable "cwagent_force_flush_interval" {
  description = "Maximum amount of seconds that logs remain in the memory buffer before being sent to the server."
  type        = number
  default     = 5
}

variable "cwagent_image" {
  description = "Container image of the Cloudwatch agent"
  type        = string
  default     = "amazon/cloudwatch-agent:1.247346.0b249609"
}

variable "fluentd_sa_name" {
  description = "Service account name for Fluentd."
  type        = string
  default     = "fluentd"
}

variable "fluentd_cr_name" {
  description = "Cluster Role name for Fluentd."
  type        = string
  default     = "fluentd-role"
}

variable "fluentd_crb_name" {
  description = "Cluster Role Binding name for Fluentd."
  type        = string
  default     = "fluentd-role-binding"
}

variable "fluentd_init_image" {
  description = "Init container for Fluentd daemonset."
  type        = string
  default     = "busybox"
}

variable "fluentd_image" {
  description = "Container image for Fluentd."
  type        = string
  default     = "fluent/fluentd-kubernetes-daemonset:v1.7.3-debian-cloudwatch-1.0"
}
