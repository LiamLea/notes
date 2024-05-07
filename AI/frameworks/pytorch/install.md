# install 


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [install](#install)
    - [部署（以nvidia为例）](#部署以nvidia为例)
      - [1.安装nvidia的driver](#1安装nvidia的driver)
      - [2.安装pytorch](#2安装pytorch)
      - [3.验证](#3验证)

<!-- /code_chunk_output -->


### 部署（以nvidia为例）

[参考](https://pytorch.org/get-started/locally/)

#### 1.安装nvidia的driver
[参考gpu部分](../../../computer/OS/linux_os/operating_system/basic/GPU.md)

* 查看cuda版本
```shell
nvidia-smi
```

* pytorch有自己的cuda runtime API，所以不需要安装toolkit
* **pytorch的cuda version 不能大于 实际的cuda version**，可以小于

#### 2.安装pytorch
根据具体环境（cuda version等信息），生成安装命令进行安装
* pytorch的cuda version 不能大于 实际的cuda version，可以小于


#### 3.验证
```python
import torch
torch.cuda.is_available()
```