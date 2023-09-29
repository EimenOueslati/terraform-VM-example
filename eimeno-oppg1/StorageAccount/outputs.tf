output "storage_account_id_output" {
    value = azurerm_storage_account.sa.primary_access_key
}