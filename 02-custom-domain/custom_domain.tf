variable "domain_name" {
  description = "Domain name to manage."
  type        = string
  default     = "daph-pocs.acmetest.org"
}

variable "is_auth0_enterprise" {
  description = "Control for toggling Auth0 Enterprise account requirements."
  type        = bool
  default     = false
}

# Create DNS Zone for managed domain
resource "azurerm_dns_zone" "example" {
  name                = var.domain_name
  resource_group_name = azurerm_resource_group.example.name
}

# Create Auth0 Custom Domain Request
resource "auth0_custom_domain" "my_custom_domain" {
  count  = var.is_auth0_enterprise ? 1 : 0
  domain = "login.${var.domain_name}"
  type   = "auth0_managed_certs"
}

# Create necessary DNS record for domain verification
resource "azurerm_dns_txt_record" "example" {
  count = var.is_auth0_enterprise ? 1 : 0
  name  = "${auth0_custom_domain.my_custom_domain[0].domain}.${auth0_custom_domain.my_custom_domain[0].verification[0].methods[0].name}"
  record {
    value = "${auth0_custom_domain.my_custom_domain[0].verification[0].methods[0].record}."
  }

  zone_name           = azurerm_dns_zone.example.name
  resource_group_name = azurerm_resource_group.example.name
  ttl                 = 300

  tags = {
    Environment = "Production"
  }
}

# Submit verification request to Auth0
resource "auth0_custom_domain_verification" "my_custom_domain_verification" {
  depends_on = [azurerm_dns_txt_record.example]
  count      = var.is_auth0_enterprise ? 1 : 0

  custom_domain_id = auth0_custom_domain.my_custom_domain[0].id

  timeouts { create = "15m" }
}
