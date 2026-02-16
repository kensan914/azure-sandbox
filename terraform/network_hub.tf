################################
# Hub VNet
################################
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-${var.project}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.hub_vnet_address_space
}

################################
# Hub Subnets
################################
resource "azurerm_subnet" "hub_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_bastion_subnet_prefix]
}

resource "azurerm_subnet" "hub_management" {
  name                 = "snet-hub-management"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_management_subnet_prefix]
}

################################
# NSG - Hub Management
################################
resource "azurerm_network_security_group" "hub_management" {
  name                = "nsg-hub-management-${var.project}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet_network_security_group_association" "hub_management" {
  subnet_id                 = azurerm_subnet.hub_management.id
  network_security_group_id = azurerm_network_security_group.hub_management.id
}
