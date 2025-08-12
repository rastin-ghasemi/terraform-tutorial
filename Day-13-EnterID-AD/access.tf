resource "azurerm_resource_group" "rg" {
  name     = "test-rg-nocharge-gh"  # Free (just a container)
  location = "eastus"            # Free-tier eligible region
}

resource "azurerm_storage_account" "example" {
  name                     = "teststorage123gh"  # Must be globally unique!
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.rg.location
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
    environment = "test"
  }
}

# RBAC Assignment (Only education group gets Contributor access)
resource "azurerm_role_assignment" "dept_access" {
  for_each = azuread_group.education

  scope                = azurerm_storage_account.example.id
  role_definition_name = "Contributor"
  principal_id         = each.value.id
}