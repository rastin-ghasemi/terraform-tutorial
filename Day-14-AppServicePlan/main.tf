resource "azurerm_resource_group" "rg" {
    name = "${var.perfix}-rg"
    location = "canadacentral"
  #    location            = "eastus"

  
}
resource "azurerm_service_plan" "asp" {
    name = "${var.perfix}-asp"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku_name = "S1"
    os_type = "Linux"
  
}
resource "azurerm_linux_web_app" "prod" {
  name                = "${var.perfix}-12314-prod"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id  # Shared ASP

  site_config {
    always_on = true  # Required for slots
  }
}

# Staging Slot (Runs on the SAME App Service Plan)
resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.prod.id  # Parent app

  site_config {
    always_on = true
  }
}