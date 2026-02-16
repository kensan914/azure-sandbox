location    = "japaneast"
project     = "azuresandbox"
environment = "dev"

# Network
hub_vnet_address_space   = ["10.0.0.0/16"]
spoke_vnet_address_space = ["10.1.0.0/16"]

hub_bastion_subnet_prefix             = "10.0.0.0/26"
hub_management_subnet_prefix          = "10.0.2.0/24"
spoke_app_integration_subnet_prefix   = "10.1.0.0/24"
spoke_private_endpoints_subnet_prefix = "10.1.1.0/24"

# App Service
app_service_plan_sku = "B1"
web_app_name         = "app-azuresandbox-web"
api_app_name         = "app-azuresandbox-api"
