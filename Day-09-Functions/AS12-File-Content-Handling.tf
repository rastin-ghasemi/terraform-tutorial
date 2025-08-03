locals {
  config_content=sensitive(file(config.json)) # The File Should be in root Directory
}
output "config" {
  value = nonsensitive(jsondecode(local.config_content))
}