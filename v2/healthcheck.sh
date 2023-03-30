#!/bin/bash

date

az login --service-principal -u $SP_APP_ID -p $SP_SECRET --tenant $TENANT_ID

if [ $? != 0 ]; then
  echo "az login failed"
  echo
  exit
fi

# Get VM public ip address
pip=$(az vm show -d -g $RG_NAME -n $VM_NAME --query publicIps -o tsv)

echo "Start testing Outline server $pip:27909 connectivity"

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
	--resource-group $RG_NAME \
	--nic-name $NIC_NAME \
	--name $IPCONFIG_NAME \
	--remove PublicIpAddress

echo "Delete the public IP"
az network public-ip delete -g $RG_NAME -n $PIP_NAME

echo "Create a new public IP"
az network public-ip create \
	--resource-group $RG_NAME \
	--name $PIP_NAME \
	--sku Standard \
	--version IPv4 \
	--location $LOCATION \
	--zone 1 2 3

echo "Update ipconfig with new public IP" 
az network nic ip-config update \
	--resource-group $RG_NAME --nic-name $NIC_NAME \
  --name $IPCONFIG_NAME --public-ip-address $PIP_NAME


newIP=$(az vm show -d -g $RG_NAME -n $VM_NAME --query publicIps -o tsv)

echo "ss://$VPN_PWD@$newIP:27909/?outline=1" > ./VPNAccessKey

echo "Rotate Outline access key with new public IP $newIP"
az storage blob upload --account-name $SA_NAME \
	--account-key $STORAGE_ACCOUNT_KEY \
	--container-name $CONTAINER_NAME \
	--file ./VPNAccessKey \
	--name $BLOB_NAME \
	--overwrite

echo "Done"
echo
