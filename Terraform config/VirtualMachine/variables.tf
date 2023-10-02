variable "base_name" {
    type = string
    description = "The base name for all the resources in the module"
}

variable "location" {
    type = string
    description = "The Azure region that the resources should be deployed in" 
}

variable "subnet_id" {
    type = string
    description = "The subnet if for the IP adress of the virtual machine"
}

variable "admin_username" {
    type = string
    description = "The admin username of the virtual machine"
  
}

variable "vm_passwd" {
    type = string
    description = "The password for the admin user"
  
}