variable "location" {
    type = string
    description = "The Azure region that the resources should be deployed in"
  
}

variable "sa_base_name" {
    type = string
    description = "The base name for the storage account resource"
}

variable "sa_backend_key" {
    type = string
    description = "The name to distinguish the storage account key for the tfstate file storage"
}


variable "vn_base_name" {
    type = string
    description = "The base name for the virtual network resource"
}

variable "vn_backend_key" {
    type = string
    description = "The name to distinguish the virtual network key for the tfstate file storage"
}

variable "vm_base_name" {
    type = string
    description = "The base name for the virtual machine resource"
}
  
variable "vm_backend_key" {
    type = string
    description = "The name to distinguish the virtual machine key for the tfstate file storage"
}