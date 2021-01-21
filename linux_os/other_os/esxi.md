# ESXi
[toc]

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
