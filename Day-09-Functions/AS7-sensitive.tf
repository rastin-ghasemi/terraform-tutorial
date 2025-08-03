variable "backup-name" {
    default = "daily_backup"
    type = string
    validation {
      condition = endswith(var.backup-name,"_backup")
    error_message = "backup should end with _backup"
    }
}


variable "credential" {
    default = "xyz123"
    type = string
    sensitive = true
}

output "backup" {
    value = var.backup-name
  
}

output "credential_output" {
    value = var.credential
    sensitive = true
  
}
