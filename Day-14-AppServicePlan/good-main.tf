# Configure the Azure provider
provider "azurerm" {
  features {}
}

variable "prefix" {
  description = "Prefix for all resources"
  default     = "myapp"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "canadacentral"
}

# App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = "${var.prefix}-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "S1"
  os_type             = "Linux"
}

# Production Web App (main branch)
resource "azurerm_linux_web_app" "prod" {
  name                = "${var.prefix}-prod"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = true
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "18-lts"
    "ENVIRONMENT"                  = "production"
  }
}

# Staging Web App Slot (develop branch)
resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.prod.id

  site_config {
    always_on = true
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "18-lts"
    "ENVIRONMENT"                  = "staging"
  }
}

# Feature branch deployment slot
resource "azurerm_linux_web_app_slot" "feature" {
  name           = "feature-x"
  app_service_id = azurerm_linux_web_app.prod.id

  site_config {
    always_on = true
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "18-lts"
    "ENVIRONMENT"                  = "feature"
  }
}