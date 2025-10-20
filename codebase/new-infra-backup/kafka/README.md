# BankiFi Platform

This Terraform module creates all resources required to have infrastructure needed for the BankiFi Platform. The module **does not install** the platform itself, that is being managed elsewhere, but it does set up everything needed to be able to install the platform.

The main resources being created by this module are as follows:

* MongoDB clusters and databases
* Kafka infrastructure
* An optional CDN for static resources
* Private keys and other security requirements

# Migration to v0.4.5 or newer

Makes sure that all resources within the desired workspace that take in the `vendor_name` or `vendor_email` parameters now accept `partner_name` and `partner_email` instead. 


# Migration to v0.5.x or newer

Prior to version v0.5 only a single instance of the bankifi platform was supported. With the addition of extra development environments within the cluster, the creation of the k8s namespaces and platform required resources is now done dynamically. The following resources would need to be imported for each sub environment present.

1. Upgrade the module version within the desired workspace
2. Import the following resources for each existing platform namespace using `terraform import ...`:
    * Critical resources:
        * `azurerm_storage_container.mobile_assets`
        * `azure_cdn_profile.cdn`
        * `azure_cdn_endpoint.mobile`
        * `platform_kafka[0].azurerm_eventhub_namespace.kafka_eventhubs`
        * `mongodbatlas_project.platform`
        * `mongodbatlas_cluster.cluster`

   * All resources:
        * `module.bankifi_platform.azuread_group.dev_group`

        * `module.bankifi_platform.azurerm_cdn_endpoint.mobile[0]`
        * `module.bankifi_platform.azurerm_cdn_profile.cdn[0]`

        * `module.bankifi_platform.azurerm_key_vault_key.bankifi_signature`
        * `module.bankifi_platform.azurerm_key_vault_secret.jwt_shared_token`
        * `module.bankifi_platform.azurerm_key_vault_secret.kafka_connection[0]`
        * `module.bankifi_platform.azurerm_key_vault_secret.mongodb_admin_password`
        * `module.bankifi_platform.azurerm_key_vault_secret.mongodb_operator_password`
        * `module.bankifi_platform.azurerm_key_vault_secret.mongodb_operator_url`
        * `module.bankifi_platform.azurerm_key_vault_secret.superuser_password`

        * `module.bankifi_platform.azurerm_role_assignment.k8s_dev_assignment`

        * `module.bankifi_platform.azurerm_storage_container.mobile_assets[0]`

        * `module.bankifi_platform.kubernetes_namespace.`
        * `module.bankifi_platform.kubernetes_role_binding.bankifi_dev_ns_role_binding`
        * `module.bankifi_platform.kubernetes_secret.kafka_connection[0]`

        * `module.bankifi_platform.mongodbatlas_cluster.cluster`
        * `module.bankifi_platform.mongodbatlas_database_user.admin`
        * `module.bankifi_platform.mongodbatlas_database_user.operator`
        * `module.bankifi_platform.mongodbatlas_project.platform`

        * `module.bankifi_platform.module.mongodb_atlas.azurerm_firewall_application_rule_collection.mongodb_atlas`
        * `module.bankifi_platform.module.mongodb_atlas.azurerm_firewall_network_rule_collection.mongodb_atlas`
        * `module.bankifi_platform.module.mongodb_atlas.azurerm_role_assignment.peering_role_assignment`
        * `module.bankifi_platform.module.mongodb_atlas.azurerm_role_definition.peering_role`

        * `module.bankifi_platform.module.mongodb_atlas.mongodbatlas_network_container.network_container`
        * `module.bankifi_platform.module.mongodb_atlas.mongodbatlas_network_peering.peering`
        * `module.bankifi_platform.module.mongodb_atlas.mongodbatlas_project_ip_whitelist.mongo`
        * `module.bankifi_platform.module.mongodb_atlas.mongodbatlas_project_ip_whitelist.test`

        * `module.bankifi_platform.module.mongodb_databases["<db_name>"].data.mongodbatlas_cluster.cluster`
        * `module.bankifi_platform.module.mongodb_databases["<db_name>"].azurerm_key_vault_secret.mongodb_db_password`
        * `module.bankifi_platform.module.mongodb_databases["<db_name>"].kubernetes_secret.mongodb_db_config`
        * `module.bankifi_platform.module.mongodb_databases["<db_name>"].mongodbatlas_database_user.user`
        * `module.bankifi_platform.module.mongodb_databases["<db_name>"].random_password.mongodb_user`
        
        * `module.bankifi_platform.module.platform_kafka[0].azurerm_eventhub_namespace.kafka_eventhubs`
        * `module.bankifi_platform.module.platform_kafka[0].azurerm_eventhub_namespace.kafka_eventhubs`

        * `module.bankifi_platform.random_password.jwt_shared_token`
        * `module.bankifi_platform.random_password.mongodb_admin_password`
        * `module.bankifi_platform.random_password.mongodb_operator_password`
        * `module.bankifi_platform.random_password.mongodb_superuser_password`
        * `module.bankifi_platform.random_password.mongodb_admin_password`
3. After running a `terraform plan` there should be no changes