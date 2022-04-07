${jsonencode({
  "agent": {
    "region": region
  },
  "logs": {
    "metrics_collected": {
      "kubernetes": {
        "cluster_name": cluster_name, 
        "metrics_collection_interval": metrics_collection_interval
      }
    },
    "force_flush_interval": force_flush_interval,
  },
})}
