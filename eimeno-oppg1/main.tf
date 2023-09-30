terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }


  }

  backend "azurerm" {
    resource_group_name  = "rg_backend_tfstate"
    storage_account_name = "sabetfsfztzkj"
    container_name       = "tfstate"
    key                  = "operraTerra.terraform.tfstate"
  }
}




provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "random" {
}

module "StorageAccount" {
  source    = "./StorageAccount"
  base_name = var.base_name
  location  = var.location
}

module "VirtualNetwork" {
  source    = "./VirtualNetwork"
  base_name = var.base_name
  location  = var.location
}

module "VirtualMachine" {
  source         = "./VirtualMachine"
  base_name      = var.base_name
  location       = var.location
  subnet_id      = module.VirtualNetwork.subnet_id_output
  admin_username = var.vm_username
  vm_passwd      = var.vm_passwd
}

module "KeyVault" {
  source                  = "./KeyVault"
  base_name               = var.base_name
  location                = var.location
  sa_ak_secret_name       = var.sa_ak_secret_name
  sa_primary_access_key   = module.StorageAccount.storage_account_ak_output
  vm_username_secret_name = var.vm_username_secret_name
  vm_username             = var.vm_username
  vm_passwd_secret_name   = var.vm_passwd_secret_name
  vm_passwd               = var.vm_passwd
}