locals {
    workspaces_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"
    rg_name = "SA-RG-${var.base_name}-${local.workspaces_suffix}"
    location = var.location
}

resource "random_string" "sa-suffix" {
    length = 8
    special = false
    upper = false
  
}

resource "azurerm_resource_group" "sa-rg" {
  name     = local.rg_name
  location = local.location
}

resource "azurerm_storage_account" "sa" {
  name                     = "${lower(var.base_name)}${random_string.sa-suffix.result}"
  resource_group_name      = local.rg_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "sa-sc" {
  name                  = "sc-${lower(var.base_name)}"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}