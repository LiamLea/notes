# cloud-init

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [cloud-init](#cloud-init)
    - [概述](#概述)
      - [1.cloud-init](#1cloud-init)
      - [2.有两类配置](#2有两类配置)
      - [3.根据以下数据进行初始化](#3根据以下数据进行初始化)
        - [（1）cloud metadata](#1cloud-metadata)
        - [（2）user data](#2user-data)
        - [（3）vendor data](#3vendor-data)
        - [（4）cloud init的配置文件中的配置](#4cloud-init的配置文件中的配置)
    - [使用](#使用)

<!-- /code_chunk_output -->

### 概述

#### 1.cloud-init
用于多云实例进行初始化，已成为业界的标准，适用于各种云平台

#### 2.有两类配置
* `per-instance`
  * 一个实例只会执行一次，根据缓存判断实例是否执行过：`/var/lib/cloud/instances/<sn>/`

* `per-boot`
  * 每次系统启动都会执行一次

#### 3.根据以下数据进行初始化

##### （1）cloud metadata

##### （2）user data
用于输入的数据，可以支持两种格式

* cloud config data
即cloud init的配置文件格式，以`#cloud-config`开始

* 用户脚本
即可以执行用户脚本，以`#!`开始

##### （3）vendor data

##### （4）cloud init的配置文件中的配置

***

### 使用
