# get domains
data "azuread_domains" "aad" {
  only_initial = true
}
locals {
  domain_name = data.azuread_domains.add.domains.*.domain_name
  users=csvdecode(file("users.csv"))
}
output "domain" {
    value = local.domain_name
  
}
# All Info in file.csv
output "users" {
    value = local.users
  
}
# get Just First and Last name from file.csv
output "users_for" {
    value = [for user in local.users : "${user.first_name}-${user.last_name}"]
  
}