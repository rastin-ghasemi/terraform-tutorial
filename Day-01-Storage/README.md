## A beginner-friendly introduction to Azure Storage Accounts + Terraform automation

## 💡 What is an Azure Storage Account?
An Azure Storage Account is a cloud-based service that provides scalable storage for:

- Blobs (files, images, backups)

- Tables (NoSQL structured data)

- Queues (messaging between apps)

- Files (SMB/NFS file shares)

🔹 Key Features:

- Durability: Data replicated across Azure datacenters (LRS, ZRS, GRS).

- Security: Encryption at rest + role-based access control (RBAC).

- Scalability: Pay only for what you use.

.

## 🚀 Why Use Terraform?
- Infrastructure as Code (IaC): Define resources in config files (version-controlled, reusable).

- Automation: Deploy/destroy resources with one command.

- Consistency: Avoid manual errors in the Azure Portal.

## ✅ Prerequisites
1. **Azure Account (Free Tier Eligible)**

2. **Azure CLI (az login configured)**
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

3. **Terraform Installed **

## Fisrt We Should Authenticating Terraform with Azure
Before creating resources, Terraform needs permissions to manage Azure infrastructure. Here's how to authenticate securely:
## 🔑 Authentication Methods
1. **Azure CLI Authentication (Recommended for Local Development)**
```bash
az login  # Opens browser to authenticate
```
- Automatically grants Terraform access

- No credentials stored in code

- Uses your user permissions
2. **Service Principal (Recommended for CI/CD)**
```bash
az ad sp create-for-rbac -n az-demo --role="Contributor" --scopes="/subscriptions/$SUBSCRIPTION_ID"
```
Note: Use the values generated here to export the variables in the next step

- Set env vars so that the service principal is used for authentication
```bash
  "appId": "c6dec7763635f", ARM_CLIENT_ID
  "displayName": "az-demo", 
  "password": "", ARM_CLIENT_SECRET
  "tenant": "" ARM_TENANT_ID
}
sub-id = ee6b2301-c6*****-1de8b5c
export ARM_CLIENT_ID="cbf3f209********dec7763635f"
export ARM_CLIENT_SECRET="KTh8Q~****6UHImRcec"
export ARM_SUBSCRIPTION_ID="ee6b2301-********1c0551de8b5c"
export ARM_TENANT_ID="6c7e502c-4720-47e8-a688-******"
```
- You Can use Var in main.tf like this
```bash
provider "azurerm" {
  features {}
  
  subscription_id = "your-subscription-id"
  client_id       = "appId-from-above"
  client_secret   = "password-from-above"
  tenant_id       = "tenant-from-above"
}
```
## 🔒 Best Practices
- Use environment variables for secrets Like above.
Auth is done.

## Create Our main.tf File For Create a Storage Account
📜 main.tf
```bash
terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.8.0"
    }
  }
  required_version = ">=1.9.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "test-rg-nocharge-gh"  # Free (just a container)
  location = "eastus"            # Free-tier eligible region
}

resource "azurerm_storage_account" "example" {
  name                     = "teststorage123gh"  # Must be globally unique!
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"       # Cheapest non-premium tier
  account_replication_type = "LRS"            # Lowest-cost redundancy
  min_tls_version          = "TLS1_2"         # Security best practice

  # Optional: Enable soft delete (prevents accidental deletion)
  blob_properties {
    delete_retention_policy {
      days = 7  # Free for first 7 days
    }
  }

  tags = {
    environment = "test"
  }
}
```
## # Initialize Terraform

```bash
rgh@machine:~/Work/Main/Terreform/Storage-ACc$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "~> 4.8.0"...
- Installing hashicorp/azurerm v4.8.0...
- Installed hashicorp/azurerm v4.8.0 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
## # Preview changes

```bash
rgh@machine:~/Work/Main/Terreform/Storage-ACc$ terraform plan | grep -i create
  + create
  # azurerm_resource_group.example will be created
  # azurerm_storage_account.example will be created
```

```bash
rgh@machine:~/Work/Main/Terreform/Storage-ACc$ terraform validate
Success! The configuration is valid.

```
## Apply (creates resources)

```bash
terraform apply

Plan: 2 to add, 0 to change, 1 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_resource_group.example: Destroying... [id=/subscriptions/ee6b2301-c691-4551-8836-1c0551de8b5c/resourceGroups/test-rg-nocharge]
azurerm_resource_group.example: Still destroying... [id=/subscriptions/ee6b2301-c691-4551-8836-...de8b5c/resourceGroups/test-rg-nocharge, 00m10s elapsed]
azurerm_resource_group.example: Destruction complete after 19s
azurerm_resource_group.example: Creating...
azurerm_resource_group.example: Still creating... [00m10s elapsed]
azurerm_resource_group.example: Creation complete after 14s [id=/subscriptions/ee6b2301-c691-4551-8836-1c0551de8b5c/resourceGroups/test-rg-nocharge-gh]
azurerm_storage_account.example: Creating...
azurerm_storage_account.example: Still creating... [00m10s elapsed]
azurerm_storage_account.example: Still creating... [00m20s elapsed]
azurerm_storage_account.example: Still creating... [00m30s elapsed]
azurerm_storage_account.example: Still creating... [00m40s elapsed]
azurerm_storage_account.example: Still creating... [00m50s elapsed]
azurerm_storage_account.example: Still creating... [01m00s elapsed]
azurerm_storage_account.example: Still creating... [01m10s elapsed]
azurerm_storage_account.example: Creation complete after 1m18s [id=/subscriptions/ee6b2301-c691-4551-8836-1c0551de8b5c/resourceGroups/test-rg-nocharge-gh/providers/Microsoft.Storage/storageAccounts/teststorage123gh]

Apply complete! Resources: 2 added, 0 changed, 1 destroyed.
```
### Change Resources After apply
1. **Change The Main.tf**
2. **Run terraform plan**
See The Changes
3. **apply**
## Clean Resources
- One Way:
1- **Remove What You want From main.tf**
2- **Run terraform plan**
This is not good way.

- Another Way:
## Destroy everything (to avoid costs)

```bash
terraform destroy

Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

azurerm_storage_account.example: Destroying... [id=/subscriptions/ee6b2301-c691-4551-8836-1c0551de8b5c/resourceGroups/test-rg-nocharge-gh/providers/Microsoft.Storage/storageAccounts/teststorage123gh]
azurerm_storage_account.example: Destruction complete after 3s
azurerm_resource_group.example: Destroying... [id=/subscriptions/ee6b2301-c691-4551-8836-1c0551de8b5c/resourceGroups/test-rg-nocharge-gh]
azurerm_resource_group.example: Still destroying... [id=/subscriptions/ee6b2301-c691-4551-8836-...b5c/resourceGroups/test-rg-nocharge-gh, 00m10s elapsed]
azurerm_resource_group.example: Destruction complete after 18s

Destroy complete! Resources: 2 destroyed.

```
⚠️ Confirmation: Type yes when prompted.