locals {
    workspaces_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"
    storage_account_type = ["Standard", "Standard_LRS", "Standard_GRS", "Standard_RAGRS", "Standard_ZRS", "Premium_LRS"]
}

resource "random_string" "sa-suffix" {
    length = 8
    special = false
    upper = false
  
}

resource "azurerm_resource_group" "sa-rg" {
  name     = "SA-RG-${var.base_name}${local.workspaces_suffix}"
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = "${lower(var.base_name)}${random_string.sa-suffix.result}"
  resource_group_name      = azurerm_resource_group.sa-rg.name
  location                 = azurerm_resource_group.sa-rg.location
  account_tier             = local.storage_account_type[0]
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "sa-sc" {
  name                  = "sc-${lower(var.base_name)}"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}