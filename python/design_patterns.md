# design patterns
[toc]
### 1.单例模式
**（1）概述**

设定某个类只能实例化一次
* 在建立连接时很有用（能够**共享**连接）

**（2）实现**

注意：每执行一次实例化，new函数和init函数都会执行一次
```python
class A:
    #该静态变量，用于指向创建的实例
    __instance = None

    #该静态变量，用于表示init函数是否执行过，防止重复执行
    __init_flag = False


    def __new__(cls, *args, **kwargs):
        if not cls.__instance:
            cls.__instance = super().__new__(cls)
        return cls.__instance

    def __init__(self):
        if not __init_flag:
            __init_flag = True
            pass

a1 = A()
a2 = A()

#id(a1) == id(a2)
```
