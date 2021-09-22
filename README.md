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
