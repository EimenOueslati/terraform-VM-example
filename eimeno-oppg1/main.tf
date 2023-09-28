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
    backend_key = var.sa_backend_key
}

module "VirtualNetwork" {
  source = "./VirtualNetwork"
  base_name = var.vn_base_name
  location = var.location
  backend_key = var.vn_backend_key
}