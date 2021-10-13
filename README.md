# Hippo - PaaS

## Introduction
Hippo is the easiest way to deploy and serve applications compiled to
[WebAssembly](https://webassembly.org/).

**WARNING:** This is experimental code. It is not considered production-grade
by its developers, nor is it "supported" software.

> DeisLabs is experimenting with many WASM technologies right now. This is one
> of a multitude of projects (including
> [Krustlet](https://github.com/deislabs/krustlet)) designed to test the limits
> of WebAssembly as a cloud-based runtime.

Hippo takes a fresh spin on the PaaS ecosystem, taking advantage of the
technology WebAssembly brings to the space.

Hippo works like this: A WebAssembly package is bundled up as a
[bindle](https://github.com/deislabs/bindle). Bindles are collected together in
a bindle server that you can search. Hippo uses bindle under the hood for
storing and organizing applications.

Hippo provides a web interface for users to register new accounts, access their
applications, and create new environments for testing.

Hippo makes it easy to run WebAssembly applications and services at scale.

## Documentation

If you're new to the project, get started with [the
introduction](https://docs.hippofactory.dev/intro/). For more in-depth
information about Hippo, plunge right into the [topic
guides](https://docs.hippofactory.dev/topics/).

## Running locally 
When running the server locally you will need to install [multipass](https://multipass.run/).  
This is an open source project from canonical which will work on Windows, MacOS and Linux. So what ever you OS you choose to develop on multipass will have you covered. This is the only dependency of the project. 
Once multipass is installed just run the following 
```
curl -L -o cloud-init.yaml 'https://github.com/scotty-c/hipo-dev/blob/main/cloud-init.yaml
multipass launch --name hippo-server --cpus 2 --mem 4G --disk 20G --cloud-init cloud-init.yaml
```

Once that is finshed you can enter the shell by running the following command
```
multipass shell hippo-server
```  

To get access to the Hippo webpage first get the ip address of your multipass instance with 

```
multipass info hipo-server   
```  
You will get an output like 
```  
Name:           hipo-server
State:          Running
IPv4:           10.83.163.61
Release:        Ubuntu 20.04.3 LTS
Image hash:     da8cdaf57235 (Ubuntu 20.04 LTS)
Load:           1.62 2.18 1.37
Disk usage:     4.3G out of 19.2G
Memory usage:   543.1M out of 3.8G
Mounts:         --
```
We will use the IPv4 address, mine is `10.83.163.61` (please note your ip could be different)on port 5001
```
https://10.83.163.61:5001
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
