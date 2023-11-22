# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.安装pyspark](#1安装pyspark)
        - [(1) 环境变量: PYSPARK_PYTHON](#1-环境变量-pyspark_python)

<!-- /code_chunk_output -->


### 概述

#### 1.安装pyspark

* 根据使用的spark版本确定pyspark版本
```shell
conda create -n pyspark pyspark=<version>
```

##### (1) 环境变量: PYSPARK_PYTHON
* 指定driver和executors使用的python解释器
  * 如果不指定，则会使用默认的

* 在pycharm中使用ssh时，可以这样指定
```python
import  os
import sys

os.environ['PYSPARK_PYTHON'] = sys.executable
```