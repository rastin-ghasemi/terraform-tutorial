terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.8.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-day02"  # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "day02180"                      # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"                       # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "dev.terraform.tfstate"        # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
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