## count in Terraform: Dynamic Resource Creation
The count parameter in Terraform allows you to create multiple instances of the same resource or module dynamically. It’s a powerful feature for scaling infrastructure without duplicating code.

## Basic Syntax (EX1.tf)
```bash
resource "azurerm_resource_group" "example" {
  count    = 3  # Creates 3 identical resource groups
  name     = "rg-${count.index}-example"  # Uses index (0, 1, 2)
  location = "eastus"
}
```
- count.index: A special variable that starts at 0 and increments for each iteration.

Output 3 RGs named:

- rg-0-example

- rg-1-example

- rg-2-example

## Conditional Resource Creation (EX2.tf)
```bash
variable "enable_backup" {
  type    = bool    # Only accepts `true` or `false`
  default = true    # Default value (backup enabled unless explicitly disabled)
}
```
```bash
resource "azurerm_backup_policy" "example" {
  count       = var.enable_backup ? 1 : 0  # Ternary operator
  name        = "backup-policy"
  resource_group_name = azurerm_resource_group.example.name
}
```
Key Components:
- Ternary Operator (? :):

- Syntax: condition ? value_if_true : value_if_false

- Similar to if-else in programming.

count Behavior:

- count = 1 → Resource is created.

- count = 0 → Resource is ignored.

## Combining count with Lists/Maps
Create VMs from a List:
```bash
variable "vm_names" {
  type    = list(string)
  default = ["web", "db", "cache"]
}

resource "azurerm_virtual_machine" "example" {
  count         = length(var.vm_names)  # 3 VMs
  name          = "vm-${var.vm_names[count.index]}"
  resource_group_name = azurerm_resource_group.example.name
  # ... (other VM configs)
}
```
Outputs:

- vm-web, 
- vm-db, 
- vm-cache,
## Create Resources from a Map:
```bash
variable "regions" {
  type = map(string)
  default = {
    "east"  = "eastus"
    "west"  = "westus2"
  }
}

resource "azurerm_resource_group" "example" {
  for_each  = var.regions  # Alternative to `count` (Terraform 0.12+)
  name      = "rg-${each.key}"
  location  = each.value
}
```
Outputs:

- rg-east (in eastus)

- rg-west (in westus2)

## Limitations of count
1. **All resources are identical except for count.index.**

2. **Deleting an item mid-list shifts indexes (can cause unintended destroys).**

3. **Not ideal for complex dependencies.**

- Alternative: Use for_each (Terraform 0.12+) for more flexibility.

##  Referencing count-Based Resources
Access a Specific Instance:
```bash
# Get the name of the first RG
output "first_rg_name" {
  value = azurerm_resource_group.example[0].name
}
```
Access All Instances:
```bash
# Get all RG names as a list
output "all_rg_names" {
  value = [for rg in azurerm_resource_group.example : rg.name]
}
```
## When to Use count
- Scaling identical resources (e.g., multiple VMs with the same config).

- Conditional creation (e.g., count = var.create_resource ? 1 : 0).

- Simple loops (when order doesn’t matter)

## for_each in Terraform: Complete Guide
Terraform's for_each allows you to create multiple instances of a resource or module using a map or set of strings, providing better control and stability than count.

## Basic Syntax
Using a Set of Strings
```bash
resource "aws_instance" "example" {
  for_each      = toset(["web", "db", "cache"])  # Converts list to a set
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "server-${each.key}"  # "web", "db", "cache"
  }
}
```
Output:

- 3 EC2 instances named server-web, server-db, server-cache.

## Using a Map
```bash
variable "servers" {
  type = map(object({
    ami        = string
    cpu        = number
  }))
  default = {
    "web"  = { ami = "ami-123456", cpu = 2 }
    "db"   = { ami = "ami-789012", cpu = 4 }
  }
}

resource "aws_instance" "example" {
  for_each      = var.servers
  ami           = each.value.ami
  instance_type = "t${each.value.cpu}.micro"
  tags = {
    Name = "server-${each.key}"  # "web", "db"
  }
}
```
Output:

- server-web (AMI: ami-123456, 2 vCPUs)

- server-db (AMI: ami-789012, 4 vCPUs)

