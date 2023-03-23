# blueprinnt

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [blueprinnt](#blueprinnt)
    - [概述](#概述)
      - [1.Blueprint（蓝图）](#1blueprint蓝图)
      - [2.特点](#2特点)
    - [使用](#使用)
      - [1.基本使用](#1基本使用)

<!-- /code_chunk_output -->

### 概述

#### 1.Blueprint（蓝图）
* 用于组织目录结构
  * 当url（即view函数）比较多时，可以分散在不同文件中，蓝图可以组织这些文件，将url注册到app路由系统中
* 相当于将一个app分割成多个小的app

#### 2.特点
* 可以设置 独立的 模板路径/静态文件路径
* 可以设置 独立的 请求扩展（比如：berfore_request）

***

### 使用

#### 1.基本使用
注意：
  * 蓝图的名称不要跟下面的view函数名称取一样，否则，导入蓝图的时候可能出错
  * 所以蓝图对象名称可以加个前缀`blue_`

参数：
  * `name`：蓝图的名称，该蓝图中的endpoint的前缀
  * `import_name`：设置import_name，帮助定位蓝图的位置（设为`__name__`即可）
```python
from flask import Blueprint

blue_xx = Blueprint(name = "<NAME>", import_name = __name__)

@blue_xx.route("<URL>")
def func():
    return ""

#则访问由url_prefix + route组合而成的url，就会执行func视图函数
app.register_blueprint(blue_xx, url_prefix = "<URL>")
```
