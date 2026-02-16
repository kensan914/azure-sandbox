################################
# App Service Plan (shared)
################################
resource "azurerm_service_plan" "main" {
  name                = "asp-${var.project}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
}

################################
# Web App (Next.js - Public)
################################
resource "azurerm_linux_web_app" "web" {
  name                = var.web_app_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id

  public_network_access_enabled = true
  virtual_network_subnet_id     = azurerm_subnet.spoke_app_integration.id

  site_config {
    application_stack {
      node_version = "24-lts"
    }
    app_command_line = "node server.js"
  }

  app_settings = {
    "API_BASE_URL" = "https://${var.api_app_name}.azurewebsites.net"
  }
}

################################
# API App (FastAPI - Private)
################################
resource "azurerm_linux_web_app" "api" {
  name                = var.api_app_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id

  public_network_access_enabled = false

  site_config {
    application_stack {
      python_version = "3.13"
    }
    app_command_line = "uvicorn main:app --host 0.0.0.0 --port 8000"
  }

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
  }
}
