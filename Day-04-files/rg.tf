resource "azurerm_resource_group" "example" {
  name     = "test-rg-nocharge-gh"  # Free (just a container)
  location = "eastus"            # Free-tier eligible region
}