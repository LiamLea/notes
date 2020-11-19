# 包管理
[toc]
### 概述

#### 1.包

当一个目录下有`__init__.py`这个文件（可以为空）时，这个目录即为一个包

#### 2.包的特点
* 当被import时，`__init__.py`文件里的内容就会被执行（在整个程序的生命周期中，多次import，只会执行一次）
  * 所以`__init__.py`里一般 import 该目录下的文件 或者 文件中的方法 和 类等，
  * 这样可以从该包中，直接 import 已经import到该包中的对象
</br>
* 比如有以下目录结构：
```python
demo
  |
  package
    |
    __init__.py
    |
    a.py
    |
    b.py
  |
  main.py
```
* `__init__.py`  
```python
from . import a
from .b import funcA
```
* `main.py`
```python
from package import a
from package import funcA
```

#### 3.限制可以import的内容：`__all__`

在文件中设置`__all__ = ["属性1"]`
则该文件只有 属性1 能够被import

***

### import

#### 1.import 语句执行两个步骤
##### （1）找到模块，加载和初始化
* **初始化**：创建一个模块对象，**执行模块**
  * 在整个程序中只会进行**一次**初始化，再被import时，就不会执行初始化了

##### （2）在当前命名空间中，创建一个引用与该模块绑定
* import本质是 在**当前命名空间**中，创建一个 **引用**，与 指定模块对象（import）或 模块中的变量（from xx import yy）绑定
  * 所以当有多个模块，同时导入一个模块时，多个模块操作的都是 **同一个对象**
