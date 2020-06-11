# design patterns
[toc]
### 1.单例模式
**（1）概述**
设定某个类只能实例化一次
* 在建立连接时很有用（能够**共享**连接）

**（2）实现**
```python
class A:
    __instance = None

    def __new__(cls, *args, **kwargs):
        if not cls.__instance:
            cls.__instance = super().__new__(cls)
        return cls.__instance

    def __init__(self):
        pass

a1 = A()
a2 = A()

#id(a1) == id(a2)
```
