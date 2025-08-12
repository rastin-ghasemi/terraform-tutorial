resource "azurerm_key_vault" "main" {
  name                       = "${var.resource_prefix}-kv-${random_id.suffix.hex}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  tags = local.common_tags
}

# Generate random suffix for unique key vault name
resource "random_id" "suffix" {
  byte_length = 4
}

# Get current Azure client config
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  certificate_permissions = [
    "Create", "Delete", "DeleteIssuers", "Get", "Import", "List", "ManageContacts", 
    "ManageIssuers", "Purge", "Recover", "SetIssuers", "Update"
  ]
}

resource "azurerm_key_vault_access_policy" "vmss" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.vmss.principal_id

  certificate_permissions = [
    "Get"
  ]
}
resource "azurerm_key_vault_certificate" "ssl" {
  name         = "ssl-certificate"
  key_vault_id = azurerm_key_vault.main.id

  certificate {
    contents = filebase64(var.tls_certificate_path)
    password = var.tls_certificate_password # Must provide the password
  }

  depends_on = [azurerm_key_vault_access_policy.current_user]
}
resource "azurerm_user_assigned_identity" "vmss" {
  name                = "${var.resource_prefix}-vmss-identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}