locals {
    #This is used to distinguish between the different workspaces
    workspaces_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"
    vm_sizes= ["Standard_F2", "Standard_F4", "Standard_F8", "Standard_F16", "Standard_F32", "Standard_F64", "Standard_F72"]
}

resource "azurerm_resource_group" "vm-rg" {
  name     = "VM-RG-${var.base_name}${local.workspaces_suffix}"
  location = var.location
}

resource "azurerm_public_ip" "pip" {
  name                = "PIP-${var.base_name}"
  resource_group_name = azurerm_resource_group.vm-rg.name
  location            = azurerm_resource_group.vm-rg.location
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "nic" {
  name                = "NIC-${var.base_name}"
  location            = azurerm_resource_group.vm-rg.location
  resource_group_name = azurerm_resource_group.vm-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm${lower(var.base_name)}"
  resource_group_name = azurerm_resource_group.vm-rg.name
  location            = azurerm_resource_group.vm-rg.location
  size                = local.vm_sizes[0]
  admin_username      = var.admin_username
  admin_password      = var.vm_passwd
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}