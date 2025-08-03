locals {
  
user_locations    = ["eastus", "westus", "eastus"]
default_locations = ["centralus"]
unique_location= toset(concat(local.user_locations,local.default_locations))
}
output "unique_loca" {
    value = local.unique_location
}