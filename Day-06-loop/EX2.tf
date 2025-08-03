variable "enable_backup" {
  type    = bool    # Only accepts `true` or `false`
  default = true    # Default value (backup enabled unless explicitly disabled)
}

resource "azurerm_backup_policy" "example" {
  count       = var.enable_backup ? 1 : 0  # Ternary operator
  name        = "backup-policy"
  resource_group_name = azurerm_resource_group.example.name
}