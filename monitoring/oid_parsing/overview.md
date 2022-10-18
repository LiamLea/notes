# overview

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.mibs库](#1mibs库)
      - [2.分析流程](#2分析流程)
        - [（1）首先判断厂商：`1.3.6.1.2.1.1.1.2`](#1首先判断厂商136121112)
        - [（2）判断设备类型](#2判断设备类型)

<!-- /code_chunk_output -->

### 概述

#### 1.mibs库
一些mibs库下载地址，能够加载到本地，从而能够解析oid，具体参考snmp.md文件
* [librenms](https://github.com/librenms/librenms/tree/master/mibs)
* [netdisco](https://github.com/netdisco/netdisco-mibs)

#### 2.分析流程

##### （1）首先判断厂商：`1.3.6.1.2.1.1.1.2`

[enterprises-number](https://www.iana.org/assignments/enterprise-numbers/enterprise-numbers)

##### （2）判断设备类型
* [h3c-product-id](https://github.com/librenms/librenms/blob/master/mibs/HH3C-PRODUCT-ID-MIB)

* [huawei-product-id](https://github.com/librenms/librenms/blob/master/mibs/huawei/HUAWEI-MIB)

* [cisco-product-id](https://github.com/librenms/librenms/blob/master/mibs/cisco/CISCO-PRODUCTS-MIB)
