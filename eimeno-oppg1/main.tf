terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.69.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}

module "StorageAccount" {
    source = "./StorageAccount"
    base_name = var.sa_base_name
    location = var.location 
}