
# # // Set Local Variable
locals {
  /* Resource name prefix NON PROD environments */
  resource_name = "${var.name_prefix}-${var.env}"

  # /* Resource name prefix PROD environments */
  # resource_name = "${var.name_prefix}-${var.primary_location}"

  /* Global DNS Records */
  dns_resource_group = data.terraform_remote_state.bankifilabs_global.outputs.dns_resource_group_name
  root_domain        = data.terraform_remote_state.bankifilabs_global.outputs.root_domain
  # develop_domain     = "${var.namespace_name}.${var.sub_domain_name}.${var.root_domain}"
  # test_domain        = "test.${var.sub_domain_name}.${var.root_domain}"
  # demo_domain        = "demo.${var.sub_domain_name}.${var.root_domain}"
  # prod_domain        = var.root_domain

#   /* TODO: Do we need Container Register per Workspace ? */
  central_registry_id = data.terraform_remote_state.bankifilabs_central.outputs.container_registry_id

#   /* Tags and K8S labels */
  tags = {
    Environment = var.env
    ManagedBy   = var.managedby
    Owner       = var.owner
    Partner     = var.partner_name
  }

  k8s_common_labels = {
    "app.kubernetes.io/managed-by" = var.managedby
    "app.kubernetes.io/part-of"    = var.owner
    "k8s.bankifi.com/environment"  = var.env
    "k8s.bankifi.com/owner"        = var.owner
    "k8s.bankifi.com/partner"      = var.partner_name
  }
}
