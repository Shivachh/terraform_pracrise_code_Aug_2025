locals {
    resource_group_name = "${var.prefix}-rg-${var.suffix}"
    vnet_name = "${var.prefix}-vnet-${var.suffix}"
    subnet_name = "${var.prefix}-subnet-${var.suffix}"
    public_ip_name = "${var.prefix}-public_ip-${var.suffix}"
    nic_name = "${var.prefix}-nic-${var.suffix}"
    nsg_name = "${var.prefix}-nsg-${var.suffix}"
    vm_name = "${var.prefix}-vm-${var.suffix}"
}