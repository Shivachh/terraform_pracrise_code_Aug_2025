variable "prefix" {
  type    = string
  default = "test"
}

variable "suffix" {
  type    = string
  default = "learning"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefix" {
  description = "The address prefix for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "public_ip_allocation_method" {
  description = "The allocation method for the public IP address"
  type        = string
  default     = "Dynamic" # Options: "Dynamic" or "Static"
}

variable "nic_ip_configuration" {
  description = "values for the NIC IP configuration"
  type        = map(string)
  default     = {
    name                              = "internal"
    private_ip_address_allocation     = "Dynamic"
  }
}

variable "security_rules" {
  description = "List of security rules"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "admin_username" {
  description = "The administrator username for the virtual machine"
  type        = string
  default     = "azureuser"
  sensitive   = true
}

variable "admin_password" {
  description = "The administrator password for the virtual machine"
  type        = string
  default     = "P@ssw0rd1234!"
  sensitive   = true
}


variable "vm_os_disk_settings" {
  description = "Settings for the OS disk of the virtual machine"
  type = object({
    caching              = string
    storage_account_type = string
  }) 
}

variable "vm_source_image_reference" {
  description = "The source image reference for the virtual machine"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}
  