## data source 
A data source in Terraform is like asking for information about a resource that already exists but was not created by your current Terraform code.

## Example Scenarios:
- Another team created a resource (like a VPC, database, or storage bucket), and you need to use it.

- A cloud provider has default resources (like an AWS AMI or Azure image) that you want to reference.

- You need data from an API or file (like getting the latest IP ranges from AWS).

## How It Works
- You don’t manage the resource (you won’t modify or delete it).

- You just fetch details (like ID, name, IP) to use in your Terraform code.

