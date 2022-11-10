terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 0.34.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {}
}

# Configure Auth0 Provider
provider "auth0" {
}

# Configure Azure Provider
provider "azurerm" {
  features {
    key_vault {
      # Precent soft-delete recovery on recreation
      purge_soft_delete_on_destroy = true
    }
  }
}

# Create globally shared resources
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West US 3"
}
