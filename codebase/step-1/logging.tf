# // Step 15 - Deploy Logging 
# /* https://github.com/BankiFi/terraform-k8s-logzio */
# module "logzio" {
#   source  = "app.terraform.io/BankiFi/logzio/k8s"
#   version = "1.0.0"

#   logzio_repository         = "logzio/logzio-fluentd"
#   logzio-log-listener       = var.logzio-log-listener
#   logzio-log-shipping-token = var.logzio-log-shipping-token

#   included_namespaces = "kubernetes.var.log.containers.**_asb_** kubernetes.var.log.containers.**_cash_** kubernetes.var.log.containers.**_incomeing_** kubernetes.var.log.containers.**_revenu_** kubernetes.var.log.containers.**_dev_** kubernetes.var.log.containers.**_test_** kubernetes.var.log.containers.**_inf_** kubernetes.var.log.containers.**_cards_** kubernetes.var.log.containers.**_coop_** kubernetes.var.log.containers.**_admin_** kubernetes.var.log.containers.**_aqua_** kubernetes.var.log.containers.**_opal_** kubernetes.var.log.containers.**_topaz_** kubernetes.var.log.containers.**_cncf_** kubernetes.var.log.containers.**_gogetpaid_** kubernetes.var.log.containers.**_mars_** kubernetes.var.log.containers.**_jupiter_** kubernetes.var.log.containers.**_pluto_**"

#   env               = var.env
#   k8s_common_labels = local.k8s_common_labels
#   tags              = local.tags
# }

# resource "azurerm_key_vault_secret" "logzio_log_shipping_token" {
#   name  = "logzio-log-shipping-token"
#   value = var.logzio-log-shipping-token

#   key_vault_id = module.keyvault_infra.key_vault_id

#   tags = local.tags
# }
