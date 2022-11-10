output "api_identifier" {
  value = auth0_resource_server.resource_server.identifier
}

output "client_identifier" {
  value = auth0_client.microservice_client.id
}

output "id_keyvault_id" {
  value = azurerm_key_vault_secret.auth0-client-id.id
}

output "secret_keyvault_id" {
  value = azurerm_key_vault_secret.auth0-client-secret.id
}
