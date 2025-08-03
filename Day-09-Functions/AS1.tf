locals {
  formatted_name = lower(replace("Project ALPHA Resource", " ", "-"))
}

resource "azurerm_resource_group" "example" {
  name     = "${local.formatted_name}-example"  # Using the locally computed value
  location = "eastus"              # Free-tier eligible region
}

output "resource_group_name" {
  value       = azurerm_resource_group.example.name
  description = "The name of the created resource group"
}
