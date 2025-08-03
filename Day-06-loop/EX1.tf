resource "azurerm_resource_group" "example" {
  count    = 3  # Creates 3 identical resource groups
  name     = "rg-${count.index}-example"  # Uses index (0, 1, 2)
  location = "eastus"
}
