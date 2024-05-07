# GPU


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [GPU](#gpu)
    - [概述](#概述)
      - [1.driver](#1driver)
      - [2. cuda version vs cuda toolkit version](#2-cuda-version-vs-cuda-toolkit-version)
    - [使用](#使用)
      - [1.查看gpu相关信息](#1查看gpu相关信息)
        - [(1) 查看gpu 及其 使用的driver](#1-查看gpu-及其-使用的driver)
        - [(2) 查看图片化使用的gpu](#2-查看图片化使用的gpu)
      - [2.切换nvidia driver](#2切换nvidia-driver)
        - [(1) 查看推荐driver](#1-查看推荐driver)
        - [(2) 安装推荐的driver](#2-安装推荐的driver)
        - [(3) 重启并关闭secure boot](#3-重启并关闭secure-boot)
        - [(4) 检查](#4-检查)
        - [(5) enable nvidia](#5-enable-nvidia)
        - [(6) 设置图形化界面使用intel gpu](#6-设置图形化界面使用intel-gpu)

<!-- /code_chunk_output -->


### 概述

#### 1.driver

* kernel中会内置一些driver（以modules的形式）
* 如果需要手动安装driver的会，建议安装支持dkms(dynamic kernel modules support)的，这样更新kernel后，driver也会自动更新，否则可能无法使用

#### 2. cuda version vs cuda toolkit version

[区别](https://docs.nvidia.com/cuda/cuda-runtime-api/driver-vs-runtime-api.html)

* cuda version就是nvidia driver API的version

```shell
nvidia-smi
```

* cuda toolkit是**编译**工具，提供**runtime** API（这个版本不能高于cuda version）
  * 该工具用于源码 构建
  * pytorch有自己的cuda runtime API，所以不需要安装这个
```shell
nvcc -V
```

***

### 使用

#### 1.查看gpu相关信息

##### (1) 查看gpu 及其 使用的driver
```shell
lshw -C display

#configuration: driver=nouveau latency=0
```

##### (2) 查看图片化使用的gpu
* 以gnome为例：
    * settings -> About -> Graphics

#### 2.切换nvidia driver

* [debian参考](https://wiki.debian.org/NvidiaGraphicsDrivers)

##### (1) 查看推荐driver
```shell
ubuntu-drivers devices

#driver   : nvidia-driver-535 - distro non-free recommended
```

##### (2) 安装推荐的driver
```shell
apt-get install nvidia-driver-535
```

##### (3) 重启并关闭secure boot

* 重启
* 进入bios，disable secure boot

##### (4) 检查
```shell
nvidia-smi
```

##### (5) enable nvidia
* 查看支持的profile

```shell
prime-select 
#Usage: /usr/bin/prime-select nvidia|intel|on-demand|query
```

* enable nvidia gpu
```shell
prime-select on-demand
```

* 如果切换为intel的profile则会disable nvidia gpu

##### (6) 设置图形化界面使用intel gpu
[参考](https://askubuntu.com/questions/1061551/how-to-configure-igpu-for-xserver-and-nvidia-gpu-for-cuda-work/1099963#1099963)

```shell
$ vim /etc/X11/xorg.conf

Section "Device"
    Identifier      "intel"
    Driver          "intel"
    BusId           "PCI:0:2:0"
EndSection

Section "Screen"
    Identifier      "intel"
    Device          "intel"
EndSection

#BusId通过该命令查看：lspci  | grep VGA
```

* 检查
```shell
nvidia-smi
#processes 那一部分就看不到xorg的内容了，证明xorg不是用的nvidia gpu
```