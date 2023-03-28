# Create an Elastic Kubernetes Cluster (EKS)
In this lab you will create a Kubernetes cluster on AWS (EKS)

## Prerequisites
The AWS CloudShell does not have required utilities for creating the EKS cluster. 

Create and enter a persistent directory
```sh
mkdir -p $HOME/.local/bin
cd $HOME/.local/bin
```

Install Kubectl
```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
```

Install eksctl
```sh
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl $HOME/.local/bin
```

Install Helm
```sh
export VERIFY_CHECKSUM=false
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
sudo mv /usr/local/bin/helm $HOME/.local/bin
```


## Deploy EKS cluster 
Now that all of the utilities are installed let's get started creating a cluster! 

Deploy EKS (remember to replace "your initials") 
```sh
eksctl create cluster \
--name eks-cluster \
--nodegroup-name standard-workers \
--node-type t3.medium \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4
```

After the command completes, list the nodes: 
```sh
kubectl get nodes
```

Now list the running pods:
```sh
kubectl get pods -A
```

## Lab Complete
