# configuration


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [configuration](#configuration)
    - [概述](#概述)
      - [1.常用配置](#1常用配置)
        - [(1) 并行度配置](#1-并行度配置)
        - [(2) task slots配置](#2-task-slots配置)

<!-- /code_chunk_output -->


### 概述

[所有配置](https://nightlies.apache.org/flink/flink-docs-release-1.18/docs/deployment/config/)

#### 1.常用配置

##### (1) 并行度配置

* 一个特定算子的子任务数，称为该算子的并行度
* 一个流程序的并行度，就是所有算子中最大的并行度
```python
#单个算子并行度配置
map(...).set_parallelism(4)

#默认并行度配置
env.set_parallelism(4)
```

##### (2) task slots配置

* 配置每个taskmanager的slot数量
