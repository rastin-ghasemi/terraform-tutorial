locals {
  merge_tages=merge(var.tag1,var.tag2)
}
variable "tag1" {
    type = map(string)
    default = {
    company    = "TechCorp"
    managed_by = "terraform"
    }
}
variable "tag2" {
    type = map(string)
    default = {
    environment  = "production"
    cost_center = "cc-123"
    }
}
resource "azurerm_resource_group" "example" {
  name     = "name1-example"  # Using the locally computed value
  location = "eastus"              # Free-tier eligible region
   tags = local.merge_tages
}
