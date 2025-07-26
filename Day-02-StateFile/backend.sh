#!/bin/bash

# Configuration
RESOURCE_GROUP_NAME="tfstate-day02"
STORAGE_ACCOUNT_NAME="day02$RANDOM"
CONTAINER_NAME="tfstate"
LOCATION="eastus"

# Exit on error and print commands
set -ex

# Create resource group
az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION"

# Create storage account
az storage account create \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --name "$STORAGE_ACCOUNT_NAME" \
  --sku Standard_LRS \
  --encryption-services blob \
  --allow-blob-public-access false \
  --min-tls-version TLS1_2

# Create blob container with private access
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --public-access off

# Get storage account key and show connection information
ACCOUNT_KEY=$(az storage account keys list --resource-group "$RESOURCE_GROUP_NAME" --account-name "$STORAGE_ACCOUNT_NAME" --query '[0].value' -o tsv)

echo "Azure Storage configured for Terraform state:"
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Storage Account: $STORAGE_ACCOUNT_NAME"
echo "Container: $CONTAINER_NAME"
echo "Access Key: $ACCOUNT_KEY"