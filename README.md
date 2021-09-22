# Nerdctl - rootless containers

## Introduction
The idea behind this repo was to make it super easy to spin up a [rootless containers](https://github.com/rootless-containers) with [nerdctl](https://github.com/containerd/nerdctl) and [containerd](https://github.com/containerd/containerd).  
This will work both locally or on Azure as it based on [cloud-init](https://cloudinit.readthedocs.io/en/latest/)  

## Running locally 
When running the server locally you will need to install [multipass](https://multipass.run/).  
This is an open source project from canonical which will work on Windows, MacOS and Linux. So what ever you OS you choose to develop on multipass will have you covered. This is the only dependency of the project. 
Once multipass is installed just run the following 
```
curl -L -o cloud-init.yaml 'https://raw.githubusercontent.com/scotty-c/dev-instances/main/nerdctl/cloud-init.yaml'
multipass launch --name nerdctl --cpus 2 --mem 4G --disk 20G --cloud-init cloud-init.yaml
```

Once that is finshed you can enter the shell by running the following command
```
multipass shell nerdctl
```

For all the nerdctl commands you can find [here](https://github.com/containerd/nerdctl#command-reference)