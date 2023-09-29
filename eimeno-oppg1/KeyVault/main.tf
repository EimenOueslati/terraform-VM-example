terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.74.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg_backend_tfstate"
    storage_account_name = "sabetfsfztzkj"
    container_name       = "tfstate"
    key                  = "${var.backend_key}.terraform.tfstate"
  }
}

locals {
    workspaces_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"
    rg_name = "KV-RG-${var.base_name}-${local.workspace_suffix}"
    location = var.location
}

resource "azurerm_resource_group" "kv-rg" {
  name     = local.rg_name
  location = local.location
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "KV-${var.base_name}"
  location                    = local.location
  resource_group_name         = local.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      var.permissions[0], var.permissions[1], var.permissions[2],
    ]

    secret_permissions = [
      var.permissions[0], var.permissions[1], var.permissions[3],
    ]

    storage_permissions = [
      var.permissions[0], var.permissions[1], var.permissions[3],
    ]
  }
}

resource "azurerm_key_vault_secret" "sa_accesskey" {
  name         = var.sa_ak_name
  value        = var.sa_primary_access_key
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "vm_username" {
  name         = var.vm_username_name
  value        = var.vm_username
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "vm_passwd" {
    name         = var.vm_passwd_name
    value        = var.vm_passwd
    key_vault_id = azurerm_key_vault.kv.id
}
