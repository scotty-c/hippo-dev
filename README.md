# Hipo - PaaS

## Introduction
TODO

## Running locally 
When running the server locally you will need to install [multipass](https://multipass.run/).  
This is an open source project from canonical which will work on Windows, MacOS and Linux. So what ever you OS you choose to develop on multipass will have you covered. This is the only dependency of the project. 
Once multipass is installed just run the following 
```
curl -L -o cloud-init.yaml 'https://github.com/scotty-c/hipo-dev/blob/main/cloud-init.yaml
multipass launch --name hipo-server --cpus 2 --mem 4G --disk 20G --cloud-init cloud-init.yaml
```

Once that is finshed you can enter the shell by running the following command
```
multipass shell hipo-server
```
## Running on Azure
To run this on Azure we will use exactly the same code. We will make the assumption that you have the [Azure cli](https://docs.microsoft.com/cli/azure/install-azure-cli?WT.mc_id=opensource-0000-sccoulto) that is signed into to your subscription. 

Then just run the script `./deploy-azure.sh`  
The script will ask you a couple of questions 
```
Enter the subscription to use: 
Enter the resource group for the vm: 
Enter the name for the vm:
```
Then print out the instructions to access the server.  
Once you have access to the servers shell just `tail -f output.txt`  
The MOTD will give you the rest of the instructions. 
