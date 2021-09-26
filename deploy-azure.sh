#!/bin/bash

set -e
set -o pipefail


read -p "Enter the subscription to use: "  SUB
read -p "Enter the resource group for the vm: " RS
read -p "Enter the name for the vm: " NAME


az account set --subscription "$SUB"

curl -L -o cloud-init.txt 'https://raw.githubusercontent.com/scotty-c/hipo-dev/main/cloud-init.yaml'

az vm create \
  --resource-group "$RS" \
  --name $NAME \
  --image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest \
  --size  Standard_B2S \
  --custom-data cloud-init.txt \
  --admin-username ubuntu \
  --ssh-key-values ~/.ssh/id_rsa.pub
 
az vm open-port --port 5001 --resource-group $RS --name $NAME

IP=$(az vm show -d  --resource-group $RS --name $NAME --query publicIps -o tsv
)

echo "Access your vm with  ssh ubuntu@$IP"

rm cloud-init.txt
