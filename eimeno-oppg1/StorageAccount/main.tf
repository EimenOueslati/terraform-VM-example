terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.74.0"
    }

    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "SA-${var.base_name}"
    storage_account_name = "sabetfsfztzkj"
    container_name       = "tfstate"
    key                  = "sa.terraform.tfstate"
  }
}

resource "random_string" "sa-suffix" {
    length = 8
    special = false
    upper = false
  
}

resource "azurerm_resource_group" "sa-rg" {
  name     = "SA-${var.base_name}"
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = "${lower(var.base_name)}${random_string.random_string.result}"
  resource_group_name      = azurerm_resource_group.sa-rg.name
  location                 = azurerm_resource_group.sa-rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "sa-sc" {
  name                  = "SC-${var.base_name}"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}