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

- Install Outline VPN server in a VM
- Install outline VPN client on your phone or computer
- Using Dynamical access key in your client 
  - https://www.reddit.com/r/outlinevpn/wiki/index/dynamic_access_keys/#wiki_dynamic_access_keys
  - Using Azure Blob Storage to save real access key
- Run health script to check Outline server connection, make sure you run it within China network
  - If connection failed, update Outline server VM public IP addresss, update new access key in blob storage


You need to pass environment Variables to docker container:

SP_SECRET=
VPN_PWD=
STORAGE_ACCOUNT_KEY=
