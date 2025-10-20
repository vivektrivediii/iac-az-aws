# # // Step 12 - Azure Key Vault to Kubernetes Secret Bridge
# # //https://github.com/BankiFi/terraform-k8s-akv2k8s
# module "akv2k8s" {
#   source  = "app.terraform.io/BankiFi/akv2k8s/k8s"
#   version = "1.0.0"

#   k8s_common_labels = local.k8s_common_labels
# #   providers = {
# #     kubernetes = kubernetes.aks
# #   }
# #   depends_on = [module.aks] 
# }