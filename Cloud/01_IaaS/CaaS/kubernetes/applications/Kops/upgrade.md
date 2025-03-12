# upgrade


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [upgrade](#upgrade)
    - [upgrade k8s](#upgrade-k8s)
      - [1. Preparation](#1-preparation)
      - [2.Update kops 1.29.2 -> 1.30.4](#2update-kops-1292---1304)
      - [3. Upgrade k8s: 1.29.6 -> 1.30.10](#3-upgrade-k8s-1296---13010)
      - [4. Rolling update](#4-rolling-update)
      - [5. kubectl & Prow SSH key](#5-kubectl--prow-ssh-key)

<!-- /code_chunk_output -->


### upgrade k8s

[ref](https://kops.sigs.k8s.io/operations/updates_and_upgrades/)


#### 1. Preparation
* check drift
```shell
$ terraform plan
```
* export kops.yml
```shell
$ kops get all --name=$(KOPS_CLUSTER_NAME) --state=$(KOPS_STATE_STORE) -o yaml > kops.yaml
```

#### 2.Update kops 1.29.2 -> 1.30.4
```shell
$ kops update cluster --state=$(KOPS_STATE_STORE) --name=$(KOPS_CLUSTER_NAME) --target=terraform --out=.

# this will generate or update local terraform files according to kops version
```
```shell
$ terraform apply
```

#### 3. Upgrade k8s: 1.29.6 -> 1.30.10
```shell
$ kops upgrade cluster --state=$(KOPS_STATE_STORE) --name=$(KOPS_CLUSTER_NAME)
$ kops upgrade cluster --state=$(KOPS_STATE_STORE) --name=$(KOPS_CLUSTER_NAME) --yes

# this will configure kops state file


$ make update

# this will update local terraform files according to kops state file
```
```shell
$ terraform apply

Apply complete! Resources: 0 added, 11 changed, 0 destroyed.
```

#### 4. Rolling update
* Note: 
   * reconfigure local kubeconfig
   * reconnect to bastion via ssh after recreating bastion
   * delete pod disruption budget which prevent rolling update
```shell
$ kops rolling-update cluster --state=$(KOPS_STATE_STORE) --name=$(KOPS_CLUSTER_NAME)

$ kops rolling-update cluster --state=$(KOPS_STATE_STORE) --name=$(KOPS_CLUSTER_NAME) -v 6 --yes
```

#### 5. kubectl & Prow SSH key
```shell
$ kops export kubecfg --state=$(KOPS_STATE_STORE) --name=$(KOPS_CLUSTER_NAME) --admin=87600h --kubeconfig $(KOPS_CLUSTER_NAME)-kubeconfig

# ==> on the new bastion
$ mkdir ~/.kube
$ vim ~/.kube/config

$ vim ~/.ssh/authorized_keys

$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
$ sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```