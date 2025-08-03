# Define input variables with validation
variable "project_name" {
  type        = string
  description = "Name of the project (will be converted to lowercase with hyphens)"
  default     = "Project ALPHA Resource"
  
  validation {
    condition     = length(var.project_name) > 3 && length(var.project_name) < 50
    error_message = "Project name must be between 3 and 50 characters."
  }
}

variable "allowed_ports" {
  type        = set(number)
  description = "Set of allowed ports for NSG rules"
  default     = [80, 443, 3306]
  
  validation {
    condition     = alltrue([for p in var.allowed_ports : p > 0 && p <= 65535])
    error_message = "Ports must be between 1 and 65535."
  }
}

# Compute reusable values
locals {
  # Format resource names consistently
  formatted_name = lower(replace(var.project_name, " ", "-"))
  
  # Generate NSG rules with proper priorities
  nsg_rules = [for idx, port in var.allowed_ports : {
    name        = "allow-${port}-inbound"
    priority    = 100 + (idx * 10) # Creates priorities 100, 110, 120, etc.
    port        = port
    description = "Allow inbound traffic on TCP port ${port}"
  }]
  
  # Standard tags for all resources
  common_tags = {
    Project     = local.formatted_name
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# Reference to existing resource group
data "azurerm_resource_group" "rg" {
  name = "existing-resource-group" # Replace with your RG name
}

# Create Network Security Group with dynamic rules
resource "azurerm_network_security_group" "example" {
  name                = "${local.formatted_name}-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags

  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.port
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = security_rule.value.description
    }
  }
}

# Output useful information
output "nsg_name" {
  value       = azurerm_network_security_group.example.name
  description = "The name of the created Network Security Group"
}

output "nsg_rules_summary" {
  value       = { for rule in local.nsg_rules : rule.name => rule.port }
  description = "Map of configured NSG rules showing port numbers"
}