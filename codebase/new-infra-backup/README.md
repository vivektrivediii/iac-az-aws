# Baseline Workspace / Environment

This is the Terraform Workspace is the baseline for future environments.

## Cloud Providers

Environments require a mix of Cloud providers in order to provide with a service that has all the features needed. The important ones are as follows:

- **Azure Cloud**: This is where most of our runtime environment lives.
- **MongoDB Atlas**: Managed cloud-based MongoDB databases.

### Configuration

In order to perform any changes in any of the previous cloud providers, the user running the Terraform workspace needs to have enough permissions to create, modify and delete resources in those clouds.

The credentials for each case are as follows:

#### Azure Cloud

In Azure Cloud we use an _Active Directory Application_ named [`Terraform Cloud`](https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/Overview/appId/8d999df7-fa9c-45f6-906f-0b5931e6729e/isMSAApp/).

The following **environment variables** need to be set so the Terraform AzureRM provider can authenticate using that identity:

- `ARM_CLIENT_ID`: Unique ID of the previously mentioned `Terraform Cloud` identity.
- `ARM_CLIENT_SECRET`: Password associated with that account.
- `ARM_TENANT_ID`: Unique ID for Enviroment's Tenant ID in Azure Cloud.
- `ARM_SUBSCRIPTION_ID`: Unique ID for the target Azure Cloud subscription where the resources are going to be placed.

#### MongoDB Atlas

To be able to issue changes in the resources in MongoDB Atlas, an **API Access Key** needs to be created in MongoDB Atlas with the right permissions to perform changes. Once that key has been created, a pair of values would be available and those need to be used as **terraform variables**:

- `mongodbatlas_public_key`: Public key side of the API Access Key
- `mongodbatlas_private_key`: Private key side of the API Access Key
- 29JUL21v001 - Dummy Push to Trigger Plan
