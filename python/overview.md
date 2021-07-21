# python
[toc]

### 重要知识
python中一切皆对象，
类也是对象，是由type类创建的对象
对象的三个要素：
* id（内存地址）
* type（属于的类）
* value（值）

**注意**
python中**传值时传的都是地址**
**对象名是一个指针**，指向一个**地址**，可以通过`对象名 = xx`，改变其指向的地址
```python
a = []
b = []
a.append(b)     #传入的是b的地址
b.append(1)
print(a)        #[[1]]

a = []
b = []
a.append(b)
b = [1]         #此时p这个指针不再执行原来的列表，而指向了新的列表
print(a)       #[[]]
```
这两个例子的区别是
* 列表是一个可变对象，所以a列表中存放的是b列表的引用，所以在b列表中添加元素时，a也跟着变化了
* 当给b赋值时，b就指向了其他地址，而不是原先的b列表的地址，所以a不会跟着变化

***

### 基础概念

#### 1.python虚拟化环境
（1）图形化创建
>settings -> project -> project interpreter -> add local... -> 指定虚拟环境的目录和python的目录 -> 确定 -> 选择解释器(即选择了虚拟环境)

（2）命令行创建
```shell
python3 -m venv 目录      #该虚拟环境使用的是python3
source 目录/bin/activate

#此时就进入python虚拟环境了,退出输入:deactivate
#交换式直接输入python
#执行python脚本:python xx.py
```

#### 2.上下文管理器：with语句

* 当执行with方法时，会调用对象的`__enter__`方法
* `__enter__`返回值就会赋值给变量`f`
* 当with语句执行结束时，会调用对象的`__exit__方法`
```python
class A:
  def __enter__(self):
    return self

  def __exit__(self, type, value, traceback):
    pass

with A() as f:      
  pass
```

#### 3.所有类都是由 type类 实例化 创建的对象
* 默认定义类时，会自动**实例化type**，并**传入相关参数**，会生成type的对象，**该对象就是新的类**
```python
A = type("A", (object,), {})

#等价于

class A(obj):
  pass
```

#### 3.metaclass
用来指定当前类由谁来创建
如果不指定，默认是type创建的类的

***

### 模块
#### 1.概述
（1）一个以.py结尾的python程序就是一个模块(模块名去除.py即可)
（2）编写一个模块
```python
"""模块名
描述信息
"""
...
def xx():
  "函数描述信息"
  ...
...
```
（3）使用一个模块
**导入模块时,python在sys.path定义的路径中搜索模块**
```python
import xx         #即运行一遍该模块
help(xx)
xx.function()
xx.variable
```
（4）导入模块中的某些功能
```python
  from xx import function1,function2,...
```

（5）导入模块时起别名
```python
  import xx as yy
```

（6）每个模块都有一个特殊的变量:\_\_name\_\_    
```python
#用来控制导入模块时,是否执行相应代码
#当模块文件直接运行时,该__name__变量的值为__main__
#当模块间接运行(被import导入)时,__name__变量的值为模块名
if __name__=='__main__':     #直接输入main,然后按下tab
    ...
```
#### 2.常用简单模块
（1）随机数模块：random
```python
  import random
  random.choice(xx)           #里面可以时字符串,列表等等
  random.randint(0,9)         #包括最后一个元素
```
（2）位置参数模块：sys
```python
  import sys
  sys.argv                  #返回一个列表,包含位置参数
  sys.argv[0]               #返回程序名  
  ...
```

（3）timeit
```python
import timeit
seconds = timeit.timeit(stmt="func()", number = 10000)
#stmt(statement)，这里填语句或者函数，比如stmt="func()"
#number，表示前面语句被执行的次数，默认时100 0000次
#返回的单位是秒
```

***

### 文件操作
**文件对象是可迭代对象**
**注意 文件指针的移动**

#### 1.读取文本文件（用for循环读取,`for line in f`）
```python
  f=open('xx', encoding = "utf8")
  data=f.read()
  data=f.readline()     #读取一行
  data=f.readlines()    #读取所有行放入列表
  f.close()
```

#### 2.以bytes方式读取文件（用whiled循环读取,终止条件`if not data`）
```python
#用于处理非文本文件,如可执行程序
  f=open('xx','rb', encoding = "utf8")
  data=f.read(4096)    #括号填字节数,一个块为4096字节,所以一般一次读取4096字节
  f.close()
```
#### 3.写文本文件
```python
  f=open('xx', 'w', encoding = "utf8")    #w模式,清空或创建文件,a模式,必要时创建文件
  f.write('xx')      
  f.close()
```

#### 4.with语句
```python
 #适用于对资源访问的场合,无论是否异常退出,都会执行必要的清理操作
with open('xx') as fobj1,open('yy', encodeing = "utf8") as fobj2:
  ...
```

#### 5.移动文件指针（当打开文件后才会有 文件指针）
```python
  f.tell()        #当前文件指针所在的位置
  f.seek(-2,2)    #第一个参数是偏移量
                  #第二个参数是相对位置,0表示开头,1表示当前位置,2表示结尾
```

***

### 代码块缓存机制
#### 1.代码块
代码块作为一个执行单元，一个模块、一个函数体、一个类定义、一个脚本文件，都是一个代码块

#### 2.同一个代码块下的缓存机制
适用对象：int，bool，几乎所有的string

#### 3.不同代码块下的缓存机制
适用对象：（-5~256）的int，bool，满足规则的string

#### 4.举例
```python
a = 10
b = 10

#id(a)和id(b)是一样的，即指向同一块内存
```

***

### 反射机制
把字符串映射为某个对象的属性或方法，对象可以是任何东西（模块、类、实例等）

#### 1.`hasattr(对象, "xx")`
用于判断对象是否有xx这个属性或方法，返回True或False

#### 2.`getattr(对象, "xx")`
用于获取对象中xx这个属性或方法

* `test.name` <----> `getattr(test, "name")`
</br>
* `test.func()`  <----> `getattr(test, "func")()`
</br>
* `import m1; m1.func1()` <---> `import m1; getattr(m1, "func1")()`
</br>
* `func()` <----> `getattr(sys.modules[__name__], "func")()`
调用本模块的内容

#### 3.利用反射机制可以实现，根据配置文件的配置，执行相应的内容
目录结构
![](./imgs/overview_01.png)
```shell
#settings.py
plugins = [
    "lib.plugins.plugin1.func1",
    "lib.plugins.plugin2.func2"
]

#plugin1.py
def func1():
    print("plugin1")

#plugin2.py
def func2():
    print("plugin2")
```
```python
from settings import  plugins

import importlib

for plugin in plugins:

    #获取模块的路径和函数名
    module_path, func = plugin.rsplit(".", maxsplit = 1)

    #导入模块
    module = importlib.import_module(module_path)

    #调用模块内的函数
    getattr(module, func)()
```

***

### 迭代
#### 1.可迭代对象
（1）定义
拥有`__iter__`方法的对象，该方法用于生成迭代器，迭代器用于迭代该可迭代对象

（2）特点
* 拥有的方法多
* 占用内存

（3）例子
字符串、列表等都是可迭代对象

#### 2.迭代器
（1）定义
由可迭代对象返回的一个用于迭代的工具
拥有`__next__`方法

（2）特点
* 节省内存（最重要）
* 速度慢
* 有一个指针记录当前的位置

（3）例子
文件对象是迭代器
for语句内部机制是将可迭代对象转换成迭代器，从而进行迭代取值

***

### 生成器
#### 1.生成器定义
生成器本质就是迭代器，只不过生成器里面的内容是我们放进去的，迭代器里的内容是读取过来的

#### 2.语法
```python
yield 1
yield 2
yield 3

#相当于：
l = [1, 2, 3]
yield from l
```

#### 3.生成生成器的方式
（1）生成器函数
```python
def func():
    ...
    yield xx
    ...
    yield xx

gen = func()      #这条语句不会执行函数，只会生成一个生成器
gen.__next__()    #第一个next执行到第一个yield停下来
gen.__next__()    #第二个next继续执行，执行到第二个yield停下来
```
（2）通过 生成器表达式 生成 生成器对象
```python
(10+i for i in range(10))
('hello' for i in range(100))
```

***

### 特殊变量和函数
#### 1.概述
* `__xx`
以双下划线开头的实例变量名，是一个**私有变量（private）** ，只有内部可以访问，外部不能访问
* `__xx__`
以双下划线开头，并且以双下划线结尾的，是**特殊变量**，特殊变量是可以直接访问的，它不是private变量
* `_x`
以单下划线开头的实例变量名，这样的变量外部是可以访问的，但是，按照约定俗成的规定，当你看到这样的变量时，意思就是，“虽然我可以被访问，但是请把我视为私有变量，不要随意访问”。

#### 2.常用内置函数
|函数|说明|
|-|-|
|`dir(xx)`|用于获取对象的属性、方法名等，返回一个字符串列表|
|`id(xx)`|获取对象的内存地址|
|`type(xx)`|获取对象所属的类|
|`hasattr(xx, "yy")`</br>`getattr(xx, "yy")`|实现反射机制|
|`callable(xx)`|判断xx是否是可调用|
|`isinstance(<OBJ>, <CLASS>)`|判断`<OBJ>`是不是`<CLASS>`的实例|

#### 3.常用内置装饰器
|装饰器|说明|
|-|-|
|`@classmethod`|把一个绑定方法 修改成 一个类方法</br>当发现没必要传入self时，可以使用这个装饰器|
|`@staticmethod`|把一个绑定方法 修改成 静态方法（即与类和对象都无关|
|`@property`|用来将方法伪装成属性|

* 举例
```python
class A:

  @classmethod
  def func1(cls, args):
    pass

  @staticmethod
  def func2(args):
    pass

  def func3(self, args):
    pass

#有两种调用方式
A.func1()

a = A()
a.func1()
```

#### 特殊变量和方法（是内置对象的属性）
##### （1）通用
|属性名|说明|
|-|-|
|`__dict__`|获取类或对象的属性</br>几乎所有类和对象都有`__dict__`这个属性，有几个特殊的没有|

##### （2）模块相关
|属性名|说明|
|-|-|
|`__name__`|获取模块的`import_name`（包括路径，比如`lib.modules.nginx.scan_nginx`，如果是主模块则返回`__main__`|
|`__doc__`|获取模块的注释|
|`__file__`|获取模块的绝对路径|
|`__package__`|获取模块所在的包|
|`__all__`|当模块被from xx import * 时，`__all__`列表里定义的内容会被`import`|

* `__all__`举例
```python
# foo.py

__all__ = ['bar', 'baz']
waz = 5
bar = 10
def baz(): return 'baz'
```
```python
from foo import *
print(bar)
print(baz)
```
##### （3）类相关（魔法函数）
|属性名|说明|
|-|-|
|`__init__()`|初始化函数, 创建实例的时候，可以调用__init__方法做一些初始化的工作</br>如果子类重写了__init__，实例化子类时，则只会调用子类的__init__</br>此时如果想使用父类的__init__，可以再调用一下|
|`__new__()`|构造函数，在`__init__`之前被调用</br>`__new__`方法是一个类方法，第一参数是cls</br>主要做三件事：</br>1.创建对象的内存空间</br>2.在该空间中创建一个指针指向类</br>3.返回创建出来的对象地址|
|`__del__()`|析构函数，释放对象时调用|
|`__str__()`|当对象需要转换成字符串时,自动执行这个函数|
|`__call__()`|当对象执行调用`对象()`时,自动执行这个函数|
|`__len__()`|当`len(对象)`时，会执行这个函数|
|`__getattribute__()`|在类 里面,其实并没有方法这个东西,**所有**的东西都保存在**属性**里面</br>所谓的调用方法其实是类里面的一个**同名属性**指向了一个**函数**,</br>**返回**的是**函数的地址**,再用 **函数()** 这种方式就可以调用它|


* `__init__()`举例
```python
  def __init__(self,参数):
      父类.__init__(self,部分参数)
      #等价于:super(类名,self).__init__(部分参数)
          pass
```


* `__str__()`举例
```python
  def __str__(self):          
  #当对象需要转换成字符串时,自动执行这个函数
      return  'xx'
#如: a=A()
#print(a)，此时会返回xx
```

* `__call__()`举例
```python
  def __call__(self):    
  #当对象执行调用时,自动执行这个函数
      pass
#如: a=A()
#a()，此时会执行...处的代码
```

* `__getattribute__`举例
```python
class Demo():
    def __getattribute__(self, item):
#item形参是实例调用方法或属性时，传入的属性名（不是必须用item，可以用其他名字代替）

        #如果调用的是test，则执行执行下面的内容，最后返回一个地址
        #如果不设置这个条件，不论调用什么都会执行
        if item == "test":  

            def test_func(arg1):
                print(item,arg1)

            #这里返回的是一个函数的地址
            return test_func      

demo = Demo()
demo.test       
#会获取__getattribute__返回的地址，
#由于返回的是函数的地址，而不是一个值的地址，
#所以demo.test不会输出任何内容，

demo.test("xxx")
#会执行test_func()这个函数
```
**注意**：再__getattribute__方法中，不要使用self.xx，因为每一次调用类的属性或方法，都会执行一次__getattribute__函数，可能有问题

##### （4)对象相关
|属性名|说明|
|-|-|
|`definition.__name__`|The name of the class, function, method, descriptor, or generator instance.|
|`definition.__doc__`|获取对象的注释|

* `definition.__name__`举例
```python
def func_a():
    pass
print(func_a.__name__)      #打印该函数的名字
print(__name__)             #打印该模块的名字，由于是主模块，所以这里打印"__main__"

#输出结果：
#func_a
#__main__
```
