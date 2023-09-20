# RAM


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [RAM](#ram)
    - [概述](#概述)
      - [1.术语](#1术语)
      - [2.查看具体是哪个内存条（当内存报错时）](#2查看具体是哪个内存条当内存报错时)

<!-- /code_chunk_output -->

### 概述

#### 1.术语

|术语|说明|
|-|-|
|EDAC (error detection and correction)||
|MC (memory controller)||
|DIMM (dual in-line memory module)||

#### 2.查看具体是哪个内存条（当内存报错时）

```shell
$ cat /sys/devices/system/edac/mc/mc*/dimm*/dimm_label

CPU_SrcID#1_Ha#0_Chan#0_DIMM#0
CPU_SrcID#1_Ha#0_Chan#1_DIMM#0
CPU_SrcID#0_Ha#0_Chan#0_DIMM#0
CPU_SrcID#0_Ha#0_Chan#1_DIMM#0
CPU_SrcID#1_Ha#1_Chan#0_DIMM#0
CPU_SrcID#1_Ha#1_Chan#1_DIMM#0
CPU_SrcID#0_Ha#1_Chan#0_DIMM#0
CPU_SrcID#0_Ha#1_Chan#1_DIMM#0

# 错误日志: Sep 17 13:08:52 host-1 kernel: [ 4493.043562] EDAC MC0: 23898 CE memory read error on CPU_SrcID#1_Ha#0_Chan#0_DIMM#0 (channel:0 slot:0 page:0x3668653 offset:0x840 grain:32 syndrome:0x0 -  OVERFLOW area:DRAM err_code:0001:0090 socket:1 ha:0 channel_mask:1 rank:2)

# 能够定位到哪根内存条报错
```