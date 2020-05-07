[toc]
**注意**
python中都是引用对象
如果该对象是可变对象，则可以直接修改
如果该对象是不可变对象，则会创建一个副本，进行修改
```python
a = []
b = []
a.append(b)     #传入的是b的引用对象
b.append(1)
print(a)        #[[1]]

a = []
b = []
a.append(b)
b = [1]
print(a)       #[[]]
```
这两个例子的区别是
* 列表是一个可变对象，所以a列表中存放的是b列表的引用，所以在b列表中添加元素时，a也跟着变化了
* 当给b赋值时，b就指向了其他地址，而不是原先的b列表的地址，所以a不会跟着变化
# 基础概念
### python虚拟化环境
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

### 模块
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
### 常用简单模块
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
### 文件操作
**文件对象是可迭代对象**
**注意 文件指针的移动**

（1）读取文本文件(**用for循环读取,for line in f**)
```python
  f=open('xx', encoding = "utf8")
  data=f.read()
  data=f.readline()     #读取一行
  data=f.readlines()    #读取所有行放入列表
  f.close()
```

（2）以bytes方式读取文件(**用whiled循环读取,终止条件 if not data**)  
```python
#用于处理非文本文件,如可执行程序
  f=open('xx','rb', encoding = "utf8")
  data=f.read(4096)    #括号填字节数,一个块为4096字节,所以一般一次读取4096字节
  f.close()
```
（3）写文本文件
```python
  f=open('xx', 'w', encoding = "utf8")    #w模式,清空或创建文件,a模式,必要时创建文件
  f.write('xx')      
  f.close()
```

（4）**with语句**  
```python
 #适用于对资源访问的场合,无论是否异常退出,都会执行必要的清理操作
  with open('xx') as fobj1,open('yy', encodeing = "utf8") as fobj2:
    ...
```

（5）移动文件指针(**当打开文件后才会有 文件指针**)
```python
  f.tell()        #当前文件指针所在的位置
  f.seek(-2,2)    #第一个参数是偏移量
                  #第二个参数是相对位置,0表示开头,1表示当前位置,2表示结尾
```
# exception
* 常见异常
```python
  NameError             #没有声明或初始化对象
  IndexError
  SyntaxError           #语法错误
  KeyboardInterrupt     #用户终端(按ctrl+c)
  EOFError              #读到EOF(按ctrl+d)
  IOError               #输入/输出操作失败
```
* 处理异常
```python
  try:
    ...               //可能发生异常的程序,不会发生异常的不要放在里面
  except xx:          //多个异常:(xx1,xx2,..)
    ...               //捕获异常
  else:               //不发生异常会执行
    ...
  finally:            //无论如何都会执行
    ...
  ...                 //继续执行下面的程序,除非上面指明退出(exit())
```
* 触发异常(自己编写)
```python
如:
  if n>200:
    raise ValueError('n的值超过了200')

或者使用 断言异常:

  assert n<=200,'n的值超过了200'    //这里产生的异常是:AssertionError
```
# 生成器
**潜在可以提供很多数据**
**不会立即生成全部数据,所以节省内存空间**
**生成器对象通过迭代访问,访问一次后,里面的数据就没有了**
* 通过 生成器表达式 生成 生成器对象
```python
  (10+i for i in range(10))
  ('hello' for i in range(100))
```
* 通过函数,多次使用yeild语句 生成 生成器对象
```python
  def mygen():
    yield 10
    yield 'hello'
    n=10*2
    yield n
  mg=mygen()    //mg就是一个生成器对象
```
***
# 特殊变量和函数
### 概述
* \_\_xx
以双下划线开头的实例变量名，是一个**私有变量（private）** ，只有内部可以访问，外部不能访问
* \_\_xx__
以双下划线开头，并且以双下划线结尾的，是**特殊变量**，特殊变量是可以直接访问的，它不是private变量
* \_x
以单下划线开头的实例变量名，这样的变量外部是可以访问的，但是，按照约定俗成的规定，当你看到这样的变量时，意思就是，“虽然我可以被访问，但是请把我视为私有变量，不要随意访问”。

### 特殊变量和方法
#### 1.模块相关
##### （1）\_\_name__
获取模块的名字，如果是主模块则返回"\_\_main__"
##### （2）\_\_doc__
获取模块的注释
##### （3）\_\_file__
获取模块的绝对路径
##### （4）\_\_package__
获取模块所在的包
##### （5）\_\_all__
当模块被from xx import * 时，\_\_all__列表里定义的内容会被import
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
#### 2.类相关
##### （1）\_\_init__()
初始化函数, 创建实例的时候，可以调用__init__方法做一些初始化的工作
如果子类重写了__init__，实例化子类时，则只会调用子类的__init__，此时如果想使用父类的__init__，可以再调用一下
```python
  def __init__(self,参数):
      父类.__init__(self,部分参数)
      #等价于:super(类名,self).__init__(部分参数)
          pass
```
##### （2）\_\_new__()
构造函数，在__init__之前被调用
\_\_new__方法是一个静态方法，第一参数是cls，\_\_new__方法必须返回创建出来的实例

##### （3）\_\_del__()
析构函数，释放对象时调用

##### （4）\_\_str__()
当对象需要转换成字符串时,自动执行这个函数
```python
  def __str__(self):          
  #当对象需要转换成字符串时,自动执行这个函数
      return  'xx'
#如: a=A()
#print(a)，此时会返回xx
```

##### （5）\_\_call__()
当对象执行调用时,自动执行这个函数
```python
  def __call__(self):    
  #当对象执行调用时,自动执行这个函数
      pass
#如: a=A()
#a()，此时会执行...处的代码
```

##### （6）\_\_getattribute__()
在类 里面,其实并没有方法这个东西,**所有**的东西都保存在**属性**里面
所谓的调用方法其实是类里面的一个**同名属性**指向了一个**函数**,
**返回**的是**函数的地址**,再用 **函数()** 这种方式就可以调用它
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

#### 3.对象相关
#####（1） definition.\_\_name__
The name of the class, function, method, descriptor, or generator instance.
```python
def func_a():
    pass
print(func_a.__name__)      #打印该函数的名字
print(__name__)             #打印该模块的名字，由于是主模块，所以这里打印"__main__"

#输出结果：
#func_a
#__main__
```

##### （2）definition.\_\_doc__
获取对象的注释
