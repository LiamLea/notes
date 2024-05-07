# gpu


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [gpu](#gpu)
    - [gpu passthrough](#gpu-passthrough)
      - [1.开启 VT-D](#1开启-vt-d)
      - [2.enbale IOMMU](#2enbale-iommu)
      - [3.禁止加载nvidia driver（否则无法绑定到vfio）](#3禁止加载nvidia-driver否则无法绑定到vfio)
      - [4.配置VFIO能够绑定gpu](#4配置vfio能够绑定gpu)
      - [5.修改nova的配置](#5修改nova的配置)
      - [6.创建flavor](#6创建flavor)

<!-- /code_chunk_output -->


### gpu passthrough

#### 1.开启 VT-D
* 在bios中开启 VT-D (virtualization for technology direct I/O access)
* 检查
```shell
dmesg | grep -e "Directed I/O"
```

#### 2.enbale IOMMU
* IOMMU: input–output memory management unit
![](./imgs/gpu_01.png)

```shell
#对于intel
GRUB_CMDLINE_LINUX_DEFAULT="intel_iommu=on"

#对于AMD
GRUB_CMDLINE_LINUX_DEFAULT="iommu=pt iommu=1"

$ update-grub
```

#### 3.禁止加载nvidia driver（否则无法绑定到vfio）
```shell
$ vim /etc/modprobe.d/blacklist-nvidia.conf

#如果有其他driver需要在这里加上
blacklist nouveau
blacklist nvidia
```

#### 4.配置VFIO能够绑定gpu
* VFIO: Virtual Function I/O, VFIO is a device driver that is used to assign devices to virtual machines

* 加载vfio-pci module
    * 新版本的kernel，这个module是built-in的，不需要加载（通过`modinfo vifo-pci`查看）
```shell
$ vim /etc/modules-load.d/modules.conf
...
vfio-pci
```

* 查找显卡的Product ID 以及 Vendor ID
```shell
$ lspci -nn | grep NVIDIA
02:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK107 [GeForce GTX 650] [10de:0fc6] (rev a1)
02:00.1 Audio device [0403]: NVIDIA Corporation GK107 HDMI Audio Controller [10de:0e1b] (rev a1)
```

* 绑定gpu
```shell
$ vim /etc/modprobe.d/gpu-vfio.conf
options vfio-pci ids=10de:0fc6,10de:0e1b
```

* 重启之后验证
```shell
$ lshw -C display

# 查看gpu的driver
```

#### 5.修改nova的配置
```shell
$ vim /etc/kolla/nova-compute/nova.conf

[pci]
passthrough_whitelist: { "vendor_id": "10de", "product_id": "0fc6" }

$ docker restart nova-compute
```
```shell
$ vim /etc/kolla/nova-api/nova.conf

[pci]
alias: { "vendor_id":"10de", "product_id":"0fc6", "device_type":"type-PCI", "name":"geforce-gtx" }
[filter_scheduler]
enabled_filters = PciPassthroughFilter
available_filters = nova.scheduler.filters.all_filters

$ docker restart nova-api
```

```shell
$ vim /etc/kolla/nova-scheduler/nova.conf

[filter_scheduler]
enabled_filters = PciPassthroughFilter
available_filters = nova.scheduler.filters.all_filters

$ docker restart nova-scheduler
```

#### 6.创建flavor
```shell
openstack flavor create \
...
--property "pci_passthrough:alias"="geforce-gtx:1" \
test
# 1表示分配一个gpu
```