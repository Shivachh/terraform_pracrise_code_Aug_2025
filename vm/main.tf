#---------------- Resource Group ----------------#
resource "azurerm_resource_group" "my_rg" {
  name     = local.resource_group_name
  location = var.location
}

#---------------- Virtual Network ----------------#
resource "azurerm_virtual_network" "my_vnet" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = local.resource_group_name
  address_space        = var.vnet_address_space
}
#---------------- Subnet ----------------#
resource "azurerm_subnet" "subnet1" {
  name                 = local.subnet_name
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes      = var.subnet_prefix
}

#---------------- Public IP ----------------#
resource "azurerm_public_ip" "my_public_ip" {
  name                = local.public_ip_name
  location            = var.location
  resource_group_name = local.resource_group_name
  allocation_method    = var.public_ip_allocation_method # "Dynamic" Or "Static"
}

#---------------- Network Interface ----------------#
resource "azurerm_network_interface" "my_nic" {
  name                = local.nic_name
  location            = var.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = var.nic_ip_configuration.name
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = var.nic_ip_configuration.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.my_public_ip.id
  }
}

#---------------- Network Security Group ----------------#
resource "azurerm_network_security_group" "my_nsg" {
  name                = local.nsg_name
  location            = var.location
  resource_group_name = local.resource_group_name

  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

#---------------- Associate NSG with the Network Interface ----------------#
resource "azurerm_network_interface_security_group_association" "my_nic_nsg" {
  network_interface_id      = azurerm_network_interface.my_nic.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}

#---------------- Virtual Machine ----------------#
resource "azurerm_linux_virtual_machine" "my_vm" {
  name                = local.vm_name
  resource_group_name = local.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username       = var.admin_username
  admin_password       = var.admin_password

  os_disk {
    caching                = var.vm_os_disk_settings.caching
    storage_account_type    = var.vm_os_disk_settings.storage_account_type
  }
  source_image_reference {
    publisher = var.vm_source_image_reference.publisher
    offer     = var.vm_source_image_reference.offer
    sku       = var.vm_source_image_reference.sku
    version   = var.vm_source_image_reference.version
  }
  network_interface_ids = [
    azurerm_network_interface.my_nic.id
    ]
}
