resource "azurerm_firewall_application_rule_collection" "platform_outbound" {
  name                = "${var.name_prefix}-${var.env}-outbound-platform"
  azure_firewall_name = module.network.firewall_name
  resource_group_name = azurerm_resource_group.workspace.name

  priority = 104
  action   = "Allow"

  rule {
    name             = "companieshouse-uk"
    source_addresses = ["*"]
    target_fqdns = [
      "api.companieshouse.gov.uk"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name             = "moneyhub"
    source_addresses = ["*"]
    target_fqdns = [
      "*.moneyhub.co.uk"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name             = "sendgrid"
    source_addresses = ["*"]
    target_fqdns = [
      "api.sendgrid.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name             = "twilio"
    source_addresses = ["*"]
    target_fqdns = [
      "api.twilio.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name             = "rebrandly"
    source_addresses = ["*"]
    target_fqdns = [
      "api.rebrandly.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name             = "sage"
    source_addresses = ["*"]
    target_fqdns = [
      "*.sage.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name             = "quickbooks"
    source_addresses = ["*"]
    target_fqdns = [
      "*.intuit.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name             = "xero"
    source_addresses = ["*"]
    target_fqdns = [
      "*.xero.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name             = "logzio"
    source_addresses = ["*"]
    target_fqdns = [
      "listener-uk.logz.io",
      "listener-nl.logz.io",
      "listener-eu.logz.io",
      "listener.logz.io"
    ]

    protocol {
      port = "8071"
      type = "Https"
    }
    protocol {
      port = "8070"
      type = "Http"
    }
    protocol {
      port = "8053"
      type = "Https"
    }
  }

  rule {
    name             = "paymark"
    source_addresses = ["*"]
    target_fqdns = [
      "*.paymarkclick.co.nz"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }
  
  rule {
    name             = "mx"
    source_addresses = ["*"]
    target_fqdns = [
      "*.mx.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }
  rule {
    name             = "maverick"
    source_addresses = ["*"]
    target_fqdns = [
      "*.maverickpayments.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }  
    rule {
    name             = "recaptcha"
    source_addresses = ["*"]
    target_fqdns = [
      "*.google.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }  
  rule {
    name             = "github"
    source_addresses = ["*"]
    target_fqdns = [
      "ghcr.io"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }    
  rule {
    name             = "openai"
    source_addresses = ["*"]
    target_fqdns = [
      "api.openai.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }  
  rule {
    name             = "squareup"
    source_addresses = ["*"]
    target_fqdns = [
      "connect.squareupsandbox.com",
      "connect.squareup.com",
      "*.connect.squareup.com",
      "*.connect.squareupsandbox.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }  
  rule {
    name             = "praetura"
    source_addresses = ["*"]
    target_fqdns = [
      "*.praeview.co.uk"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }  
  rule {
    name             = "taggun"
    source_addresses = ["*"]
    target_fqdns = [
      "api.taggun.io"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  } 
  rule {
    name             = "tavily"
    source_addresses = ["*"]
    target_fqdns = [
      "api.tavily.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }
}