# deploy

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [deploy](#deploy)
    - [部署](#部署)
      - [1.前提准备](#1前提准备)
        - [（1）内核加载kvm模块](#1内核加载kvm模块)
        - [（2）检查](#2检查)
        - [（3）kubernetes要求](#3kubernetes要求)
      - [2.安装kubevirt](#2安装kubevirt)

<!-- /code_chunk_output -->

### 部署

#### 1.前提准备

##### （1）内核加载kvm模块
所有机器上加载kvm_intel（或者kvm_amd）模块

##### （2）检查

```shell
#yum -y install libvirt-client
virt-host-validate qemu
```

##### （3）kubernetes要求
* apiserver
  * `--allow-privileged=true`
* container runtime
  * `containerd`
  * `crio (with runv)`
  * 其他可能不支持

#### 2.安装kubevirt
```shell
export RELEASE=$(curl https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt)
wget https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt-operator.yaml
wget https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt-cr.yaml

kubectl apply -f kubevirt-operator.yaml
kubectl apply -f kubevirt-cr.yaml
kubectl -n kubevirt wait kv kubevirt --for condition=Available
```

* 安装virsh命令
[参考](https://kubevirt.io/user-guide/operations/virtctl_client_tool/)
```shell
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  HTTPS_PROXY="http://10.10.10.250:8123" curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  HTTPS_PROXY="http://10.10.10.250:8123" ./"${KREW}" install krew
)

HTTPS_PROXY="http://10.10.10.250:8123" NO_PROXY="10.0.0.0/8" kubectl krew install virt
```

* 创建虚拟机
```shell
kubectl apply -f https://kubevirt.io/labs/manifests/vm.yaml
kubectl get vms
kubectl virt start testvm
kubectl virt console testvm
```
