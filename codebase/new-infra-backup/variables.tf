// Environment Wide Variable - Variable Values from Terraform Cloud
variable "env" {}
variable "primary_location" {}
variable "name_prefix" {}
variable "root_domain" {}
variable "partner_name" {}
variable "partner_email" {}
variable "managedby" {}
variable "owner" {}
variable "environment_type" {}
variable "domain_name_type" {}
variable "sub_domain_name" {}
variable "integration_type" {}
variable "appname" {}
variable "site_to_site_trust_store_password" {}
variable "site_to_site_vpn_shared_key" {}

variable "subenvironments" {
  description = "Contains subenvironment details required by the platform module"
  type        = map(any)
}

// 
variable "dns_resource_group" {
  type = string
}

// Subscription to deploy DNS Resources -  Default PAYG
variable "dns_subscription" {
  type    = string
  default = "03124817-ae3a-4193-9790-1725e5f089fe"
}

// Subscription to deploy Environment Resources -  Default PAYG
variable "resource_subscription" {
  type    = string
  default = "03124817-ae3a-4193-9790-1725e5f089fe"
}

// 
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.32.6"
}

// MongoDB Atlas
variable "mongodbatlas_org_id" {
  description = "MongoDB Atlas Organisation ID"
  type        = string
}

variable "mongodbatlas_public_key" {
  description = "MongoDB Atlas Public Key"
  type        = string
}

variable "mongodbatlas_private_key" {
  description = "MongoDB Atlas Public Key"
  type        = string
}

variable "mongodbatlas_adminteam" {
  description = "Team ID for Admin Access"
  type        = string
}

variable "mongodbatlas_devteam" {
  description = "Team ID for Developers Access"
  type        = string
}

// Third Parties Secrets

variable "companieshouseuk_api_key" {
  description = "UK Companies House API Key"
  type        = string
  default     = null
}

variable "hmrc_client_id" {
  description = "HMRC Client ID"
  type        = string
  default     = null
}

variable "hmrc_client_secret" {
  description = "HMRC Client Secret"
  type        = string
  default     = null
}

variable "hmrc_server_token" {
  description = "HMRC Server Token"
  type        = string
  default     = null
}

variable "xero_client_secret" {
  description = "Xero Client Secret"
  type        = string
  default     = null
}

variable "sage_client_secret" {
  description = "Sage Client Secret"
  type        = string
  default     = null
}

variable "sage_signing_secret" {
  description = "Sage Signing Secret"
  type        = string
  default     = null
}

variable "quickbooks_client_secret" {
  description = "QuickBooks Client Secret"
  type        = string
  default     = null
}

variable "moneyhub_client_id" {
  description = "MoneyHub's Client ID"
  type        = string
  default     = null
}

variable "moneyhub_client_secret" {
  description = "MoneyHub's Client Secret"
  type        = string
  default     = null
}

variable "moneyhub_public_key" {
  description = "MoneyHub's Public Key"
  type        = string
  default     = null
}

variable "moneyhub_private_key" {
  description = "MoneyHub's Private Key"
  type        = string
  default     = null
}

variable "moneyhub_kid" {
  description = "MoneyHub's KID"
  type        = string
  default     = null
}

// Logzio Variables
# variable "logzio-log-shipping-token" {
#   description = "Logzio Shipping Token"
#   type        = string
# }

# variable "logzio-log-listener" {
#   description = "Logzio URL for shipping logs"
#   type        = string
# }

# variable "logzio-metrics-url" {
#   description = "Logzio metrics shipping URL"
#   type        = string
# }

# variable "logzio-metrics-token" {
#   description = "Logzio metrics shipping token"
#   type        = string
# }

# variable "logzio-tracer-region" {
#   description = "Logzio tracer region"
#   type        = string
# }

# variable "logzio-tracer-token" {
#   description = "Logzio tracer shipping token"
#   type        = string
# }

// Site to Site VPN Configuration and Deployment
/* variable "public_cert_data" {
  type = string
  description = "Public key of Root certificate for configuring VPN connection between workspace and developers local machines"
} */
# variable "location" {
#   type = string
# }

variable "artifactory_password" {
  description = "Password for Artifactory"
  type        = string
  sensitive   = true
}

variable "public_cert_data" {
  description = "Public certificate data"
  type        = string
}

variable "artifactory_username" { 
  type = string 
  default = null 
  }
variable "grafana_github_client_secret" {
   type = string 
   default = null 
   }
# variable "public_cert_data" {
#    type = string 
#    default = null 
#    }
