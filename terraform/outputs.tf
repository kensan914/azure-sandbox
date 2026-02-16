output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "web_app_url" {
  value = "https://${azurerm_linux_web_app.web.default_hostname}"
}

output "api_app_url" {
  value = "https://${azurerm_linux_web_app.api.default_hostname}"
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke.id
}

output "api_private_endpoint_ip" {
  value = azurerm_private_endpoint.api.private_service_connection[0].private_ip_address
}
