terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateportfolio"
    container_name       = "tfstate"
    key                  = "portfolio.tfstate"
  }
}

provider "azurerm" {
  features {}
}
