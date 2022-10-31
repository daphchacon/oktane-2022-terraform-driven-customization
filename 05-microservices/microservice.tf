variable "keyvault_id" {
  description = "The Azure KeyVault Resource Identifier to save the client ID and secret in"
  type = string
}

# Create the microservice resources
module "microservice1" {
  source      = "./modules/microservice"
  keyvault_id = var.keyvault_id

  name = "microservice-a"

  dependencies = [{
    identifier = module.microservice3.api_identifier
    scopes     = ["delete:baz"]
  }]

  # Provide Auth0 client configurations
  client_config = {
    callbacks           = ["https://a.example.com/callback"]
    allowed_origins     = ["https://a.example.com"]
    allowed_logout_urls = ["https://a.example.com"]
    web_origins         = ["https://a.example.com"]
  }

  defined_scopes = [{
    value       = "create:foo"
    description = "Creates foos"
    }, {
    value       = "create:bar"
    description = "Create bars"
  }]

  # Pass-in pre-configured providers
  providers = {
    azurerm = azurerm
    auth0   = auth0
  }
}

module "microservice2" {
  source      = "./modules/microservice"
  keyvault_id = var.keyvault_id

  name = "microservice-b"

  dependencies = [{
    identifier = module.microservice1.api_identifier
    scopes     = ["create:foo"]
  }]

  client_config = {
    callbacks           = ["https://b.example.com/callback"]
    allowed_origins     = ["https://b.example.com"]
    allowed_logout_urls = ["https://b.example.com"]
    web_origins         = ["https://b.example.com"]
  }

  defined_scopes = [{
    value       = "delete:foo"
    description = "removes Foos"
    }, {
    value       = "create:baz"
    description = "creates bazs"
  }]

  providers = {
    azurerm = azurerm
    auth0   = auth0
  }
}

module "microservice3" {
  source      = "./modules/microservice"
  keyvault_id = var.keyvault_id

  name = "microservice-c"

  dependencies = [{
    identifier = module.microservice1.api_identifier
    scopes     = ["create:foo"]
    }, {
    identifier = module.microservice2.api_identifier
    scopes     = ["create:baz"]
  }]

  client_config = {
    callbacks           = ["https://c.example.com/callback"]
    allowed_origins     = ["https://c.example.com"]
    allowed_logout_urls = ["https://c.example.com"]
    web_origins         = ["https://c.example.com"]
  }

  defined_scopes = [{
    value       = "delete:bar"
    description = "removes bars"
    }, {
    value       = "delete:baz"
    description = "removes bazs"
  }]

  providers = {
    azurerm = azurerm
    auth0   = auth0
  }
}
