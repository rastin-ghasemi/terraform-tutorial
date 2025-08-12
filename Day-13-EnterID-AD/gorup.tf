resource "azuread_group" "Education" {
  display_name = "Education Department"
  security_enabled = true
}
resource "azuread_group_member" "education" {
  for_each = { for u in azuread_user.users: u.mail_nickname => u if u.department == "Education" }

  group_object_id  = azuread_group.engineering.id
  member_object_id = each.value.id
}
resource "azuread_group" "managers" {
  display_name = "Education - Managers"
  security_enabled = true
}

resource "azuread_group_member" "managers" {
  for_each = { for u in azuread_user.users: u.mail_nickname => u if u.job_title == "Manager" }

  group_object_id  = azuread_group.managers.id
  member_object_id = each.value.id
}

resource "azuread_group" "engineers" {
  display_name = "Education - Engineers"
  security_enabled = true
}

resource "azuread_group_member" "engineers" {
  for_each = { for u in azuread_user.users: u.mail_nickname => u if u.job_title == "Engineer" }

  group_object_id  = azuread_group.engineers.id
  member_object_id = each.value.id
}

###################################################################################################
# better way to create multi gp
#locals {
#  departments = ["engineer", "managers", "Education"]
#}
#resource "azuread_group" "department" {
#  for_each         = toset(local.departments)
#  display_name     = "grp-${each.key}"
#  security_enabled = true
#}
