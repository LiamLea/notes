# packages management


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [packages management](#packages-management)
    - [pip](#pip)
      - [1.导出相关包](#1导出相关包)
      - [2.安装whl包](#2安装whl包)
      - [3.设置pip仓库](#3设置pip仓库)
    - [源码包](#源码包)
      - [1.安装一个python包](#1安装一个python包)

<!-- /code_chunk_output -->


### pip


#### 1.导出相关包

* 以`requirements.txt`格式列出已安装的包
```shell
pip freeze > requirements.txt
```

* 下载相关包
```shell
pip download -d <dir> -r requirements.txt
```

#### 2.安装whl包
```shell
pip install *.whl
```

#### 3.设置pip仓库

* 安装nginx
* 将whl包移动到指定目录
```shell
mv -f *.whl <pip_dir>
```
* 生成索引
```shell
dir2pi -S <pip_dir>
```

***

### 源码包

#### 1.安装一个python包
```shell
cd <dir>

pip3 -r requirements.txt
python3 setup.py install
```