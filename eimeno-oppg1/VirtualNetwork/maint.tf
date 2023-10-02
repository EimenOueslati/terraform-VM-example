locals {
    #This is used to distinguish between the different workspaces
    workspaces_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"
}

resource "azurerm_resource_group" "vn-rg" {
  name     = "VN-RG-${var.base_name}${local.workspaces_suffix}"
  location = var.location
}

resource "azurerm_network_security_group" "nsg" {
  name                = "NSG-${var.base_name}"
  location            =azurerm_resource_group.vn-rg.location
  resource_group_name = azurerm_resource_group.vn-rg.name

   security_rule {
    name                       = "Allow-Public-IP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.allowed_ip
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "VNET-${var.base_name}"
  location            = azurerm_resource_group.vn-rg.location
  resource_group_name = azurerm_resource_group.vn-rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "subnet01" {
  name                 = "subnet01-${var.base_name}"
  resource_group_name  = azurerm_resource_group.vn-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  subnet_id                 = azurerm_subnet.subnet01.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}