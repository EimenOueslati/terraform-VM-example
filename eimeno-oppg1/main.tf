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

module "VirtualMachine" {
  source = "./VirtualMachine"
  base_name = var.vm_base_name
  location = var.location
  backend_key = var.vm_backend_key
  subnet_id = module.VirtualNetwork.subnet_id
  #admin_username =
  #vm_passwd =
}

module "KeyVault" {
  source = "./KeyVault"
  base_name = var.kv_base_name
  location = var.location
  backend_key = var.kv_backend_key
  sa_ak_secret_name = var.sa_ak_secret_name
  sa_primary_access_key = module.StorageAccount.sa_primary_access_key
  vm_username_secret_name = var.vm_username_secret_name
  vm_username = var.vm_username
  vm_passwd_secret_name = var.vm_passwd_secret_name
  vm_passwd = var.vm_passwd
}