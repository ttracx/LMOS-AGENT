# Azure Deployment Guide for AnythingLLM

This guide will walk you through the process of deploying AnythingLLM to Azure Container Instances (ACI) using the updated Docker Compose file.

## Prerequisites

- Azure CLI installed and configured
- Azure account with active subscription
- Docker installed on your local machine

## Step 1: Create Azure Resources

Open a terminal and run the following Azure CLI commands:

1. Create a Resource Group:

   ```bash
   az group create --name myResourceGroup --location eastus
   ```

2. Create an Azure Storage Account:

   ```bash
   az storage account create --name mystorageaccount --resource-group myResourceGroup --location eastus --sku Standard_LRS
   ```

3. Create a File Share:

   ```bash
   az storage share create --name anythingllm --account-name mystorageaccount
   ```

4. Generate a Storage Account Key:

   ```bash
   STORAGE_KEY=$(az storage account keys list --resource-group myResourceGroup --account-name mystorageaccount --query '[0].value' --output tsv)
   ```

   Make sure to save this key as you'll need it in the next step.

## Step 2: Update Docker Compose File

The `docker-compose.yml` file has already been updated for Azure deployment. Make sure it contains the correct storage account name and uses the `${STORAGE_KEY}` environment variable.

## Step 3: Deploy to Azure Container Instances

1. Set the `STORAGE_KEY` environment variable:

   ```bash
   export STORAGE_KEY=<your_storage_account_key>
   ```

   Replace `<your_storage_account_key>` with the key you obtained in Step 1.

2. Deploy the container:

   ```bash
   az container create --resource-group myResourceGroup --name anythingllm-container --file docker-compose.yml
   ```

## Step 4: Access Your Deployment

After the deployment is complete, you can get the IP address of your container instance:

```bash
az container show --resource-group myResourceGroup --name anythingllm-container --query ipAddress.ip --output tsv
```

You can now access AnythingLLM by navigating to `http://<container_ip>:3001` in your web browser.

## Notes

- Make sure to replace `mystorageaccount` with your actual storage account name if you chose a different name.
- The `STORAGE_KEY` environment variable needs to be set before running the deployment command.
- This setup uses Azure File Share for persistent storage, ensuring your data is preserved across container restarts.
- Remember to delete your resources when you're done to avoid unnecessary charges:

  ```bash
  az group delete --name myResourceGroup
  ```

If you encounter any issues during deployment, refer to the Azure Container Instances documentation or seek support from the AnythingLLM community.