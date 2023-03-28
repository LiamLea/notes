# mock

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [mock](#mock)
    - [概述](#概述)
      - [1.mock](#1mock)
      - [2.使用方式](#2使用方式)
    - [使用](#使用)
      - [1.基本使用](#1基本使用)

<!-- /code_chunk_output -->

### 概述
#### 1.mock
在单元测试中，一个单元需要依赖另一个单元的输入，则可以利用mock，模拟依赖的那个单元的输入，从而进行测试

#### 2.使用方式
* 装饰器方式（这种方式不能和参数化装饰器一起使用）
```python
@mock.patch("xx")
def test_demp(self, <NEW_FUNC_NAME>):
  pass
```

* with方式
```python
with mock.path("xx") as <NEW_FUNC_NAME>:
  pass
```

***

### 使用

#### 1.基本使用
* demo.py
```python
import os
from os import path

def rm(filename):
    if path.isfile(filename):
        print("aa")
        os.remove(filename)
```

* test.py
```python
from demo import rm
import unittest
from unittest import mock

class RmTestCase(unittest.TestCase)


# mock使用时，需要注意要模拟的对象，在相应模块中的导入方式
#比如在demo模块中：import path.os这样导入path函数
#则mock需要这样使用：mock.patch('demo.os.path')
  @mock.patch('demo.path')    #用mock_path 模拟 demo.path
  @mock.patch('demo.os')      #用mock_os 模拟 demo.os
  def test_rm(self，mock_os, mock_path):

    #默认path.isfile函数的返回值，设置False
    mock_path.isfile.return_value = False

    #调用函数
    rm("any path")

    #验证remove是否执行
    self.assertTrue(mock_os.remove.called, "如果断言判断失败，输出该信息，否则认为测试成功")
```
