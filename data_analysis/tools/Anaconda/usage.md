# deploy


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [deploy](#deploy)
    - [使用](#使用)
      - [1.安装](#1安装)
      - [2.基本使用](#2基本使用)
        - [(1) 管理conda](#1-管理conda)
      - [2.管理虚拟环境](#2管理虚拟环境)
        - [(1) 虚拟环境](#1-虚拟环境)
        - [(2) 创建虚拟环境并使用不同版本的python](#2-创建虚拟环境并使用不同版本的python)
      - [3.管理包](#3管理包)

<!-- /code_chunk_output -->


### 使用

#### 1.安装
根据系统和python版本，[下载安装脚本](https://docs.conda.io/projects/conda/en/stable/user-guide/install/download.html)

```shell
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
```

* 手动进入conda环境
```shell
# /root/miniconda3/bin/conda shell.bash hook 该命令获取脚本
# eval "..." 执行脚本（引号内为需要执行的脚本内容）
eval "$(/root/miniconda3/bin/conda shell.bash hook)"

# 上面方法无效 ，使用下面这种方法
#source ~/miniconda3/etc/profile.d/conda.sh
#conda activate base
```

* 初始化shell（这样登陆shell就会进入conda环境）（不建议）
  * 就是修改shell的profile
```shell
~/miniconda3/bin/conda init
```

#### 2.基本使用

##### (1) 管理conda
```shell
conda --version

conda info
```

* 升级
```shell
conda update conda
```

#### 2.管理虚拟环境

##### (1) 虚拟环境

* 创建虚拟环境
```shell
#创建虚拟环境，并在其中安装相应的包
conda create -n <venv> [<package_1> <package_2> ...]

#复制其他环境的包
conda create -n <venv> --clone <existing_venv>
```

* 进入指定虚拟环境
```shell
conda env list

conda activate <venv>

conda deactivate
```

##### (2) 创建虚拟环境并使用不同版本的python
```shell
conda create -n <venv> python=3.9
``` 

#### 3.管理包

* 列出已安装的包
```shell
conda list
```

* 查找指定的包
```shell
conda search <package>
```

* 安装指定包
```shell
conda install <package>
```