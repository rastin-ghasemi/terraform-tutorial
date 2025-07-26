## Variables in Terraform
Variables in Terraform allow you to customize your infrastructure without modifying the configuration files directly. They make your code more reusable and maintainable.

## Types of Variables
1. **Input Variables**
Used to parameterize your Terraform configurations. 
```bash
variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 2
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Valid values are dev, staging, or prod."
  }
}
```
The condition in a Terraform variable validation block is a logical expression that determines whether the provided variable value is acceptable. It's a powerful feature that helps ensure your variables meet specific requirements before Terraform executes your configuration. If not it will Show error Message.
2. **Output Variables**
Used to expose information about the infrastructure.
```bash
output "instance_public_ips" {
  description = "Public IP addresses of the instances"
  value       = aws_instance.web[*].public_ip
}
```

3. **Local Variables**
Used for intermediate calculations (not exposed to users).
```bash
locals {
  common_tags = {
    Environment = var.environment
    Project     = "WebApp"
  }
  
  instance_name_prefix = "${var.environment}-web-server"
}
```

## Variable Types
Terraform supports several variable types:
- Basic: string, number, bool ()

- Complex: list, set, map, object, tuple

- Special: any (default), null
```bash
variable "settings" {
  type = object({
    instance_type = string
    ami_id        = string
    tags          = map(string)
  })
  default = {
    instance_type = "t3.micro"
    ami_id        = "ami-0c55b159cbfafe1f0"
    tags          = {}
  }
}
```
## Variable Precedence in Terraform
Understanding variable precedence is crucial for effective Terraform configuration management. Here's the complete priority order from highest to lowest:
## Variable Precedence Hierarchy (Highest to Lowest)
1. **Command-line flags (-var and -var-file)**
```bash
terraform apply -var="instance_count=5" -var-file="prod.tfvars"
```
- Highest priority - overrides all other sources
2. **Environment variables (TF_VAR_ prefix)**
```bash
export TF_VAR_region="us-west-2"
export TF_VAR_instance_count=3
```
- Useful for CI/CD pipelines and automation

3. ***.auto.tfvars or *.auto.tfvars.json files**
- Automatically loaded files matching these patterns

- Example: production.auto.tfvars

4. **terraform.tfvars.json file**
```bash
{
  "instance_count": 2,
  "environment": "staging"
}
```
5. **terraform.tfvars file**
```bash
instance_count = 2
environment = "staging"
```
6. **Variable defaults (in variable declarations)**
```bash
variable "instance_count" {
  default = 1
}
```
- Lowest priority - used when no other value is provided
## Special Cases
1. **Required Variables:**
```bash
variable "db_password" {
  description = "Database password"
  sensitive   = true
  # No default makes it required
}
```
Must be provided through higher-priority methods
2. **Sensitive Variables:**
```bash
variable "api_key" {
  type      = string
  sensitive = true
}
```
Never set these in version-controlled files

3. **Dynamic Defaults:**
```bash
variable "instance_size" {
  type = string
  default = {
    dev  = "t3.small"
    prod = "m5.large"
  }[var.environment]
}
```
Calculated at runtime but still lowest priority

## Best Practices for Variable Management
- Use .auto.tfvars for environment-specific values

- Keep common defaults in variables.tf

- Use environment variables for secrets

- Employ command-line for temporary overrides

- Document all variables with descriptions

- Use variable validation rules:
```bash
variable "port" {
  type        = number
  validation {
    condition     = var.port > 1024 && var.port <= 65535
    error_message = "Must be a valid port number (1025-65535)"
  }
}
```
This precedence system allows flexible configuration while maintaining clear override capabilities. The rule of thumb: the more specific/temporary the setting method, the higher its priority.



