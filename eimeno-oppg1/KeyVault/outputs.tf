output "vm_username_output" {
    value = azurerm_key_vault_secret.vm_username.value
}

output "vm_passwd_output" {
    value = azurerm_key_vault_secret.vm_passwd.value
}
  