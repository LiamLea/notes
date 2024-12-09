# minikube


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [minikube](#minikube)
    - [Usage](#usage)
      - [1.manage cluster](#1manage-cluster)
        - [(1) create cluster](#1-create-cluster)
        - [(2) config](#2-config)
        - [(3) node management](#3-node-management)
      - [2.manage image](#2manage-image)
        - [(1) load images to node](#1-load-images-to-node)
      - [3.create services](#3create-services)

<!-- /code_chunk_output -->


### Usage

#### 1.manage cluster

##### (1) create cluster
* create a cluster and profile
```shell
# docker runtime has problem
minikube start -c containerd 

-p <profile>
--insecure-registry=[]
--image-repository=''
--kubernetes-version=''
--nodes=1
```

* list profiles
```shell
minikube profile list
```

* get status of a cluster
```shell
minikube status -p <profile>
```

* delete a cluster
```shell
minikube delete -p <profile>
```

##### (2) config
* list config of current profile
```shell
minikube config view
```

##### (3) node management
* a node is a container running in the host
* all k8s components run in the corresponding container 

```shell
minikube node list
minikube node add
```

* ssh into a node
```shell
 minikube ssh -n <node_name>
```

#### 2.manage image

##### (1) load images to node
* This image will be cached and automatically pulled into all future minikube clusters created on the machine
```shell
minikube cache add alpine:latest

minikube cache list

# reload all the cached images on demand
minikube cache reload

minikube cache delete <image name>
```

#### 3.create services
```shell
kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
kubectl expose deployment hello-minikube --type=NodePort --port=8080
```