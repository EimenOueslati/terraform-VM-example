variable "base_name" {
    type = string
    description = "The base name for all the resources in the module"
}

variable "location" {
    type = string
    description = "The Azure region that the resources should be deployed in" 
}

variable "allowed_ip" {
  type = string
    description = "The IP address that should be allowed to access the virtual machine"
}