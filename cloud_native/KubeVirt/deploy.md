# deploy

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [deploy](#deploy)
    - [部署](#部署)
      - [1.前提准备](#1前提准备)
        - [（1）内核加载kvm模块](#1内核加载kvm模块)
        - [（2）检查](#2检查)

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
