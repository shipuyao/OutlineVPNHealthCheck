# OutlineVPNHealthCheck

## Prerequisite 

- Create Service Principle and role assignment to your subscription 
  - https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal
- Install Outline VPN server and client
  - https://getoutline.org/
- Create Azure storage account to save your access key
- Create SAS URL for Outline VPN client 
  - https://learn.microsoft.com/en-us/azure/cognitive-services/translator/document-translation/how-to-guides/create-sas-tokens?tabs=blobs
  
## How does it work?

- Install Outline VPN server in Azure VM
- Install outline VPN client on your phone or computer
- Using Dynamical access key in your client 
  - https://www.reddit.com/r/outlinevpn/wiki/index/dynamic_access_keys/#wiki_dynamic_access_keys
  - Using Azure Blob Storage to save real access key
  - Example: ssconf://Azure_Blob_SAS_URL
- Run health script to check Outline server connection
  - If connection failed, update Outline server VM public IP addresss, update new access key in blob storage

## How to deploy?

- Run health check script via cron job in domestic network
- Or deploy to docker container

docker build -t shipu/vpnhealthcheck:v1 . 
docker push shipu/vpnhealthcheck:v1
docker run -d -v ${PWD}/preload.sh:/root/preload.sh shipu/vpnhealthcheck:v1

You need to set environment Variables and customize varialbe in healthcheck.sh

- SP_SECRET
- VPN_PWD
- STORAGE_ACCOUNT_KEY
