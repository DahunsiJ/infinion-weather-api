terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # pin to a major version, you can tighten to e.g. "~> 4.38" if desired
      version = ">= 4.20.0, < 5.0.0"
    }
  }
}

# NOTE: backend is configured in backend.tf (uses azurerm backend - requires the storage account/container to exist)
provider "azurerm" {
  features {}
  # Authentication via env variables in CI: ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID
}

# helpful data for use in modules
data "azurerm_client_config" "current" {}
