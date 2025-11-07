terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.120.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.50.0"
    }
  }
}
provider "azurerm" { features {} }
data "azurerm_client_config" "current" {}
