resource "azurerm_storage_account" "example" {
  name                     = "teststorage123gh"  # Must be globally unique!
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"       # Cheapest non-premium tier
  account_replication_type = "LRS"            # Lowest-cost redundancy
  min_tls_version          = "TLS1_2"         # Security best practice

  # Optional: Enable soft delete (prevents accidental deletion)
  blob_properties {
    delete_retention_policy {
      days = 7  # Free for first 7 days
    }
  }

  tags = {
    environment = "local.common_tags.environment"
  }
}