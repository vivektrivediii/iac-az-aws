# BankiFi Azure AKS Module

This module has been designed to create a Kubernetes cluster using Azure AKS service inside its own subnet in a larger virtual network. The main resources allocated by this module are as follows:

- A Subnet for the Kubernetes cluster, with addtional routing table that should be plugged into an Egress subnet and Firewall
- An AKS cluster
- An Azure Active Directory Service Principal to provide with customised access to the cluster
- An installation of [Azure Active Directory Pod Identity](https://github.com/Azure/aad-pod-identity), which is capable of assigning Azure identities to individual pods

## Migration to 0.2.x

Prior to `0.2.x` this module did not come with its own subnet resource, but it relied on the one that was being created in versions `0.1.x` of the [BankiFi Azure Network Module](https://github.com/BankiFi/terraform-azure-aks), creating a very inflexible setup between the two modules.

Starting at `0.2.x` this module now comes with its own subnet resource and the only thing it needs from [BankiFi Azure Network Module](https://github.com/BankiFi/terraform-azure-aks) is references to the egress firewall and egress subnet.

This is breaking change in the code therefore workspaces that need to upgrade from version `0.1.x` of this module to version `0.2.x` need to follow the following steps:

> **WARNING**: If these steps are not followed carefully, you may end up destroying the subnet that has been moved around and causing an outage.

1. Upgrade this module first in your target workspace
2. Perform a `terraform import ...` command of the following resources: `module.aks.azurerm_subnet.k8s`, `module.aks.azurerm_route_table.k8s` and `module.aks.azurerm_subnet_route_table_association.k8s`. This will make terraform read the state of those resources from Azure and add them into the actual Terraform State, without applying any changes.
3. Now continue with the migration steps at [BankiFi Azure Network Module](https://github.com/BankiFi/terraform-azure-aks)
4. With previous steps completed, now you are ready to do a Terraform Plan and no changes should be listed as a result of it

