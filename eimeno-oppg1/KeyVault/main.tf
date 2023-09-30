locals {
    workspaces_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"
    rg_name = "KV-RG-${var.base_name}${local.workspaces_suffix}"
    location = var.location
    key_permissions = ["Create", "List", "Get","Backup", "Decrypt", "Delete", "Encrypt", "Import", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
    secret_permissions = ["Get", "List", "Set", "Backup", "Delete", "Purge", "Recover", "Restore"]
    storage_permissions = ["Get", "List", "Set", "Backup", "Delete", "DeleteSAS", "GetSAS", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "SetSAS", "Update"]
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
      local.key_permissions[0], local.key_permissions[1], local.key_permissions[2],
    ]

    secret_permissions = [
      local.secret_permissions[0], local.secret_permissions[1], local.secret_permissions[2],
    ]

    storage_permissions = [
        local.storage_permissions[0], local.storage_permissions[1], local.storage_permissions[2],
    ]
  }
}

resource "azurerm_key_vault_secret" "sa_accesskey" {
  name         = var.sa_ak_secret_name
  value        = var.sa_primary_access_key
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "vm_username" {
  name         = var.vm_username_secret_name
  value        = var.vm_username
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "vm_passwd" {
    name         = var.vm_passwd_secret_name
    value        = var.vm_passwd
    key_vault_id = azurerm_key_vault.kv.id
}
