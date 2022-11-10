terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 0.34.0"
    }
  }
}

# Create resource server for microservice
resource "auth0_resource_server" "resource_server" {
  name       = format("%s - API", var.name)
  identifier = format("https://api.example.com/%s", var.name)

  dynamic "scopes" {
    for_each = var.defined_scopes
    content {
      value       = scopes.value.value
      description = scopes.value.description
    }
  }
}

# Create M2M client in Auth0 for microservice
resource "auth0_client" "microservice_client" {
  name                                = var.name
  app_type                            = "non_interactive"
  token_endpoint_auth_method          = "client_secret_post"
  grant_types = [
    "authorization_code",
    "http://auth0.com/oauth/grant-type/password-realm",
    "implicit",
    "password",
    "refresh_token"
  ]

  callbacks           = var.client_config.callbacks
  allowed_origins     = var.client_config.allowed_origins
  allowed_logout_urls = var.client_config.allowed_logout_urls
  web_origins         = var.client_config.web_origins
}

# Grant client access to resource server
resource "auth0_client_grant" "microservice_client_grant" {
  for_each  = { for d in var.dependencies : d.identifier => d }
  client_id = auth0_client.microservice_client.id
  audience  = each.value.identifier
  scope     = each.value.scopes
}

# Store ClientID in Key Vault for retrieval at runtime
resource "azurerm_key_vault_secret" "auth0-client-id" {
  name         = "${var.name}-id"
  value        = auth0_client.microservice_client.client_id
  key_vault_id = var.keyvault_id
}

# Store ClientSecret in Key Vault for retrieval at runtime
resource "azurerm_key_vault_secret" "auth0-client-secret" {
  name         = "${var.name}-secret"
  value        = auth0_client.microservice_client.client_secret
  key_vault_id = var.keyvault_id
}

# DEPLOY COMPUTE RESOURCES
