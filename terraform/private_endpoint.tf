################################
# Private DNS Zone
################################
resource "azurerm_private_dns_zone" "appservice" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.main.name
}

# Link to Hub VNet
resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
  name                  = "link-hub"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.appservice.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

# Link to Spoke VNet
resource "azurerm_private_dns_zone_virtual_network_link" "spoke" {
  name                  = "link-spoke"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.appservice.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

################################
# Private Endpoint for API App
################################
resource "azurerm_private_endpoint" "api" {
  name                = "pe-${var.api_app_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.spoke_private_endpoints.id

  private_service_connection {
    name                           = "psc-${var.api_app_name}"
    private_connection_resource_id = azurerm_linux_web_app.api.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.appservice.id]
  }
}
