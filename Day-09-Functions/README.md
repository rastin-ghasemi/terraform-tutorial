## Terraform Functions Learning Guide
The Terraform language includes a number of built-in functions that you can call from within expressions to transform and combine values. The general syntax for function calls is a function name followed by comma-separated arguments in parentheses:
```bash
max(5, 12, 9)

```
- For learning about each function Go to terraform Site.
## Console Commands
Practice these fundamental commands in terraform consol:
1. **First init The Backend.tf & Provider.tf
2. **Then Type :
```bash
terraform console
```
# Basic String Manipulation
- lower("HELLO WORLD")
```bash
> lower("HELLO WORLD")
"hello world"
```
- max(5, 12, 9)
```bash
> max(5, 12, 9)
12
```
trim("  hello  ")
```bash
> trim("  hello  "," ")
"hello"
```
chomp("hello\n")
```bash
> chomp("hello\n")
"hello"
```
reverse(["a", "b", "c"])
```bash
> reverse(["w","a","b","z","g"])
[
  "g",
  "z",
  "b",
  "a",
  "w",
]
```
## Assignment 1: Project Naming Convention
- Functions Focus: lower, replace

Scenario:
Your company requires all resource names to be lowercase and replace spaces with hyphens.

- Input:

"Project ALPHA Resource"
- Required Output:

"project-alpha-resource"
 
 - Done in AS1.tf 

## Assignment 2: Resource Tagging
- Function Focus: merge

Scenario:
You need to combine default company tags with environment-specific tags.

Input:

# Default tags
{
    company    = "TechCorp"
    managed_by = "terraform"
}

# Environment tags
{
    environment  = "production"
    cost_center = "cc-123"
}
Tasks:

1. Create locals for both tag sets
2. Merge them using the appropriate function
3. Apply them to a resource group
4. Create an output to display the combined tags

 - Done in AS2.tf 
## Assignment 3: Storage Account Naming
Function Focus: substr (for Counting letters)

- Scenario:
Azure storage account names must be less than 24 characters and use only lowercase letters and numbers.

- Input:

"techtutorIALS with!piyushthis should be formatted"
- Requirements:

Maximum length: 23 characters
All lowercase
No special characters
- Tasks:

Create a function to process the storage account name
Ensure it meets Azure requirements
Apply it to a storage account resource
Add validation to prevent invalid names
 - Done in AS3.tf 

## Assignment 4: Network Security Group Rules
- Functions Focus: split, join

- Scenario:
Transform a comma-separated list of ports into a specific format for documentation.

- Input:

"80,443,8080,3306"
- Required Output:

"port-80-port-443-port-8080-port-3306"
- Tasks:

Create a variable for the port list
Transform it using appropriate functions
Create an output with the formatted result
Add validation for port numbers
 - Done in AS4.tf 

## Assignment 5: Resource Lookup
Function Focus: lookup
```bash
lookup retrieves the value of a single element from a map, given its key. If the given key does not exist, the given default value is returned instead.
```
Scenario:
Implement environment configuration mapping with fallback values.

Input:
```bash
    default = {
    dev     = "standard_D2s_v3",
    staging = "standard_D4s_v3",
    prod    = "standard_D8s_v3
```
- Tasks:

1. **Create the environments map**
2. **Implement lookup with fallback**
3. **Create outputs for the configuration**
4. **Handle invalid environment names**

 - Done in AS5.tf 

## Assignment 6: VM Size Validation
- Functions Focus: length, contains

- Scenario:
Implement validation rules for VM sizes.

- Requirements:
```bash
Length between 2 and 20 characters
Must contain 'standard'
Test Cases:
```
```bash
Valid:    "standard_D2s_v3"
Invalid:  "basic_A0"
Invalid:  "standard_D2s_v3_extra_long_name"
```
- Tasks:

1. **Create a variable for VM size**
2. **Implement both validation rules**
3. **Test with various inputs**
4. **Create helpful error messages**
 - Done in AS6.tf 

## Assignment 7: Backup Configuration
Functions Focus: endswith, sensitive
endswith: takes two values: a string to check and a suffix string. The function returns true if the first string ends with that exact suffix.



- Scenario:
Create a secure backup configuration handler.

- Input:
```bash
backup_name = "daily_backup"
credential  = "xyz123" # Should be sensitive
```
Requirements:
```bash
Name must end with '_backup'
Credentials must be marked sensitive
Handle validation failures
```
- Tasks:

1. **Create variables for both inputs**
2. **Implement proper validation**
3. **Handle sensitive data correctly**
4. **Create secure outputs**
 - Done in AS7.tf 

## Assignment 8: File Path Processing
- Functions Focus: fileexists, dirname

- Scenario:
Validate Terraform configuration file paths.

Paths to Validate:
```bash
./configs/main.tf
./configs/variables.tf
```
- Tasks:

1. **Create path validation function**
2. **Extract directory names**
3. **Handle missing files**
4. **Create status outputs**
 - Done in AS8.tf 

## Assignment 9: Resource Set Management
Functions Focus: toset, concat

- Scenario:
Manage unique resource locations.

- Input:
```bash
user_locations    = ["eastus", "westus", "eastus"]
default_locations = ["centralus"]
```
-- Tasks:

1. **Combine location lists**
2. **Remove duplicates**
3. ***Create location validation**
4. **Output unique locations**

 - Done in AS9.tf 
## Assignment 10: Cost Calculation
- Functions Focus: abs, max
max takes one or more numbers and returns the greatest number from the set.
```bash
Examples
> max(12, 54, 3)
54
```
If the numbers are in a list or set value, use ... to expand the collection to individual arguments:
```bash
> max([12, 54, 3]...)
54
```

- Scenario:
Process monthly infrastructure costs.

- Input:
```bash
monthly_costs = [-50, 100, 75, 200]
```
- Required:
```bash
Convert negative values to positive
Find maximum cost
Calculate averages
```
- Tasks:

1. **Create cost processing function**
2. **Handle negative values**
3. **Calculate statistics**
4. **Create cost report output**
 - Done in AS10.tf 

## Assignment 11: Timestamp Management
- Functions Focus: timestamp, formatdate

- Scenario:
Generate formatted timestamps for different purposes.

- Required Formats:
```bash
Resource Names: YYYYMMDD
Tags: DD-MM-YYYY
```
- Tasks:

1. **Create timestamp generation**
2. **Format for different uses**
3. **Implement validation**
4. **Create formatted outputs**
 - Done in AS11.tf 

## Assignment 12: File Content Handling
- Functions Focus: file, sensitive ,jsondecode

- Scenario:
Securely handle configuration file content.

- Requirements:
```bash
Read from config.json
Mark content as sensitive
Handle file errors
Validate JSON structure
```
- Tasks:
```bash
Implement secure file reading
Add error handling
Validate file content
Create secure outputs
```
 - Done in AS12.tf 
