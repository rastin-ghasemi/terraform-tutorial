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
variable "storage_account_name" {
    type = string
    default = "techtutorIALS with!piyushthis should be formatted"
  
}
locals {
  ST-name=lower(replace(replace(substr(var.storage_account_name,0,23),"!","")," " ,""))
  merge_tages=merge(var.tag1,var.tag2)
}
resource "azurerm_resource_group" "example" {
  name     = "name1-example"  # Using the locally computed value
  location = "eastus"              # Free-tier eligible region
   tags = local.merge_tages
}
resource "azurerm_storage_account" "example" {
  name                     = local.ST-name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = local.merge_tages

}