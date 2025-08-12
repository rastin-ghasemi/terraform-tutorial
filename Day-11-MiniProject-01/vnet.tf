resource "azurerm_virtual_network" "main" {
  name                = local.resource_names.vnet
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "app" {
  name                 = local.resource_names.app_subnet
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_prefixes[0]]
}

resource "azurerm_subnet" "management" {
  name                 = local.resource_names.mgmt_subnet
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_prefixes[1]]
}

resource "azurerm_network_security_group" "main" {
  name                = local.resource_names.nsg
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags

  dynamic "security_rule" {
    for_each = [
      {
        name        = "AllowHTTP"
        priority    = 100
        direction   = "Inbound"
        access      = "Allow"
        protocol    = "Tcp"
        source_port = "*"
        dest_port   = "80"
        source_ip   = "*"
        dest_ip     = "*"
      },
      {
        name        = "AllowHTTPS"
        priority    = 110
        direction   = "Inbound"
        access      = "Allow"
        protocol    = "Tcp"
        source_port = "*"
        dest_port   = "443"
        source_ip   = "*"
        dest_ip     = "*"
      },
      {
        name        = "DenyAllInbound"
        priority    = 4096
        direction   = "Inbound"
        access      = "Deny"
        protocol    = "*"
        source_port = "*"
        dest_port   = "*"
        source_ip   = "*"
        dest_ip     = "*"
      }
    ]

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port
      destination_port_range     = security_rule.value.dest_port
      source_address_prefix      = security_rule.value.source_ip
      destination_address_prefix = security_rule.value.dest_ip
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.main.id
}