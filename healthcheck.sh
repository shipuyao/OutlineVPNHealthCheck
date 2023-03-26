#!/bin/bash
  
tenantId="144dfc9d-3e1f-4c03-8e42-27eef2458df5"
spAppId="bdd24406-7234-4bea-b9e3-69a712cd9851"
location="southeastasia"
resourceGroupName="VPN"
nicName="vpn1989"
publicIpName="VPN1-ip"
ipConfigName="ipconfig1"

date

az login --service-principal -u $spAppId -p $SP_SECRET --tenant $tenantId

if [ $? != 0 ]; then
  echo "az login failed"
  echo
  exit
fi

# Get VM public ip address
pip=$(az vm show -d -g VPN -n VPN1 --query publicIps -o tsv)

# Test Outline VPN server connection
nc -nvzw5 $pip 27909

if [ $? == 0 ]; then
  echo "Outline server connection is health, PIP rotation skipped"
  echo
  exit 0
fi

echo "Start PIP rotation"

echo "Disassociate the public IP address from the NIC"
az network nic ip-config update \
  --resource-group $resourceGroupName \
  --nic-name $nicName \
  --name $ipConfigName \
  --remove PublicIpAddress

echo "Delete the public IP"
az network public-ip delete -g $resourceGroupName -n $publicIpName

echo "Create a new public IP"
az network public-ip create \
    --resource-group VPN \
    --name VPN1-ip \
    --sku Standard \
    --version IPv4 \
    --location $location \
    --zone 1 2 3

echo "Update ipconfig with new public IP" 
az network nic ip-config update \
  --resource-group $resourceGroupName --nic-name $nicName \
  --name $ipConfigName --public-ip-address $publicIpName

echo
