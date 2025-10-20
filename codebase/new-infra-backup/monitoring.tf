# # // Step 14 - Deploy Monitoring
# # // https://github.com/BankiFi/terraform-prometheus-bankifiplatform

# # module "bankifi_monitoring" {
# #   source  = "app.terraform.io/BankiFi/bankifiplatform/prometheus"
# #   version = "1.0.0"

# #   env = var.env

# #   k8s_namespace      = module.prometheus.k8s_namespace
# #   monitor_namespaces = [for s in var.subenvironments : s.namespace_name]

# #   servicemonitor_enabled = true
# #   metrics_enabled        = true
# #   alerts_enabled         = false

# #   app_name     = module.prometheus.app_name
# #   release_name = module.prometheus.release_name

# #   k8s_common_labels = local.k8s_common_labels
# #   tags              = local.tags
# # }