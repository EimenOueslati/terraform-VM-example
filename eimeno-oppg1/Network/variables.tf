variable "base_name" {
    type = string
    description = "The base name for all the resources in the module"
}

variable "location" {
    type = string
    description = "The Azure region that the resources should be deployed in" 
}

variable "backend_key" {
    type = string
    description = "The name of the key for the backend"
}