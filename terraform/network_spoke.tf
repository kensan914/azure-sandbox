################################
# Spoke VNet
################################
resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke-${var.project}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.spoke_vnet_address_space
}

################################
# Spoke Subnets
################################
resource "azurerm_subnet" "spoke_app_integration" {
  name                 = "snet-spoke-app-integration"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.spoke_app_integration_subnet_prefix]

  delegation {
    name = "webapp-delegation"

    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}

resource "azurerm_subnet" "spoke_private_endpoints" {
  name                 = "snet-spoke-private-endpoints"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.spoke_private_endpoints_subnet_prefix]
}

################################
# NSG - Spoke App Integration
################################
resource "azurerm_network_security_group" "spoke_app_integration" {
  name                = "nsg-spoke-app-int-${var.project}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet_network_security_group_association" "spoke_app_integration" {
  subnet_id                 = azurerm_subnet.spoke_app_integration.id
  network_security_group_id = azurerm_network_security_group.spoke_app_integration.id
}

################################
# NSG - Spoke Private Endpoints
################################
resource "azurerm_network_security_group" "spoke_private_endpoints" {
  name                = "nsg-spoke-pe-${var.project}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet_network_security_group_association" "spoke_private_endpoints" {
  subnet_id                 = azurerm_subnet.spoke_private_endpoints.id
  network_security_group_id = azurerm_network_security_group.spoke_private_endpoints.id
}
