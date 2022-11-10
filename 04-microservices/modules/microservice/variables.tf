variable "keyvault_id" {
  description = "The Azure KeyVault Resource Identifier to save the client ID and secret in"
  type = string
}

variable "name" {
  description = "The name of the path component the service will be hosted at"
  type = string
}

variable "client_config" {
  description = "The allowable auth0_client configurations"
  type = object({
    callbacks           = set(string)
    allowed_origins     = set(string)
    allowed_logout_urls = set(string)
    web_origins         = set(string)
  })
}

variable "dependencies" {
  description = "The microservice dependencies grants need to be created for"
  default = []
  type = set(object({
    identifier = string
    scopes     = set(string)
  }))
}

variable "defined_scopes" {
  description = "The grant types that the API exposes"
  type = set(object({
    value       = string
    description = string
  }))
}
