#!/bin/bash

# Set Azure subscription
az account set --subscription b6c13034-12a3-49fb-9780-dce6f2c2ae7c

# Set Azure resource group
AZURE_RESOURCE_GROUP="rg-hackathon2024-team9"

# Delete existing container group
az container delete --name pulpvision-cg --resource-group $AZURE_RESOURCE_GROUP

# Deploy new container group using ARM template
az deployment group create \
    --resource-group $AZURE_RESOURCE_GROUP \
    --template-file docker/azure-deployment-template.json \
    --parameters containerGroups_pulpvision_cg_name=pulpvision-cg containerGroups_dnsNameLabel=pulpvision storageAccountName=<your_storage_account_name> storageAccountKey=<your_storage_account_key>

# Add tags to the resource group
az tag create --resource-id /subscriptions/b6c13034-12a3-49fb-9780-dce6f2c2ae7c/resourceGroups/$AZURE_RESOURCE_GROUP --tags "Application Name"="Hackathon" "Business Group"="DT" "Cost Center"="IT" "Environment"="POC" "ITSS Service"="Innovation"
