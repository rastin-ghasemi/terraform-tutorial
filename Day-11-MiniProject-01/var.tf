
variable "environment" {
  description = "Deployment environment (dev, stage, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "stage", "prod"], lower(var.environment))
    error_message = "Environment must be one of: dev, stage, prod."
  }
}
variable "location" {
  description = "Azure region (East US, West Europe, Southeast Asia)"
  type        = string
  default = "eastus"
  validation {
    condition     = contains(["eastus", "westeurope", "southeastasia"], lower(var.location))
    error_message = "Region must be one of: East US (eastus), West Europe (westeurope), or Southeast Asia (southeastasia)."
  }
}
variable "resource_prefix" {
  description = "Prefix for resource names (e.g., 'webapp')"
  type        = string
  default     = "webapp"
}

variable "vm_count" {
  description = "Initial number of VM instances in the scale set"
  type        = number
  default     = 2
}

variable "vnet_address_space" {
  description = "Address space for the virtual network (CIDR)"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}
variable "subnet_prefixes" {
  description = "Subnet CIDR blocks (app, management)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
# Create certificates directory
# mkdir -p certificates
# cd certificates

# Generate proper PFX certificate with password
#openssl req -x509 -newkey rsa:2048 -keyout server.key -out server.crt -days 365 -nodes -subj "/CN=example.com"
#openssl pkcs12 -export -out certificate.pfx -inkey server.key -in server.crt -password pass:MyPassword123!

# Clean up
#rm server.key server.crt
#cd ..
variable "tls_certificate_path" {
  description = "Path to the TLS/SSL certificate (PFX format)"
  type        = string
  default     = "./certificates/certificate.pfx"
}

variable "tls_certificate_password" {
  description = "Password for the PFX file"
  type        = string
  default     = "MyPassword123!" # Must match what you used in OpenSSL command
  sensitive   = true
}