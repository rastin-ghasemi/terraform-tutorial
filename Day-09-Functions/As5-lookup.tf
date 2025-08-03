locals {
  vm_size=lookup(var.Vmsizes,var.environment,lower(dev))
}
variable "environment" {  # Fixed typo in variable name (recommended)
  type        = string
  description = "Environment name (must be dev, staging, or prod)"
  default = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}
variable "Vmsizes" {
    type = map(string)
    default = {
    dev     = "standard_D2s_v3",
    staging = "standard_D4s_v3",
    prod    = "standard_D8s_v3",
}
}

output "vm_size" {
    value = local.vm_size
  
}