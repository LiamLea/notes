# ESXi

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [ESXi](#esxi)
    - [查用命令](#查用命令)
      - [1.虚拟机相关](#1虚拟机相关)

<!-- /code_chunk_output -->

### 查用命令

#### 1.虚拟机相关
* 获取所有虚拟机
```shell
vim-cmd vmsvc/getallvms
```

* 获取指定虚拟机的详细信息
```shell
vim-cmd vmsvc/get.guest <VMID>
```

* 列出所有虚拟机和序列号
```shell
esxcli vm process list
```
