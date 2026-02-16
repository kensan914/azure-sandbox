variable "location" {
  description = "Azure region"
  type        = string
}

variable "project" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
}

# Network
variable "hub_vnet_address_space" {
  description = "Address space for Hub VNet"
  type        = list(string)
}

variable "spoke_vnet_address_space" {
  description = "Address space for Spoke VNet"
  type        = list(string)
}

variable "hub_bastion_subnet_prefix" {
  description = "CIDR for AzureBastionSubnet"
  type        = string
}

variable "hub_management_subnet_prefix" {
  description = "CIDR for hub management subnet"
  type        = string
}

variable "spoke_app_integration_subnet_prefix" {
  description = "CIDR for App Service VNet Integration subnet"
  type        = string
}

variable "spoke_private_endpoints_subnet_prefix" {
  description = "CIDR for Private Endpoints subnet"
  type        = string
}

# App Service
variable "app_service_plan_sku" {
  description = "SKU for App Service Plan"
  type        = string
}

variable "web_app_name" {
  description = "Name of the Web App"
  type        = string
}

variable "api_app_name" {
  description = "Name of the API App"
  type        = string
}
