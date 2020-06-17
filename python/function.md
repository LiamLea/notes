[toc]
# 函数
###基础
**注意**：传入都是引用对象，
如果该对象是可变对象，则可以直接在函数内对其进行改变，
如果该对象是不可变对象，则会创建一个副本
比如：
  a=2，这个就是不可变对象
  a=[]，这个就是可变对象
#### 1.传参的方式
```python
  def func(name,age,hobby):
    ...
```
>全部使用值的方式(必须按照顺序)
```python
   func('liyi',20,'book')
```
>全部使用键值对的方式(不需要按照顺序)
```python
   func(hobby='book',name='liyi',age=20)
```
>值和键值对结合的方式(值必须写在最前面,且按照顺序)
```python
   func('liyi',hobby='book',age=20)
```

#### 2.使用参数组表示函数的形参

**当不知有多少参数和参数的具体类型时使用**
>\* 表示使用元组接收参数
```python
  def func(*targs):
      print(targs)
  func(1,2)         #输出(1,2)
```
>** 表示使用字典接收参数
```python
  def func(**kwargs):
      print(kwargs)
  func(name='liyi',age=20)   #输出:{'name':'liyi','age':20}
```
>可以混合使用
```python
  def func(*targs,**kwargs):    #字典参数组必须写在后面
      ...
```

**func(\*args,\*\*kwargs)这样的函数能接收任意参数**
>因为*args会用元组来接受，当它无法接受时，\*\*kwargs会接着接受  
\*\*kwargs是用字典来接受参数   
因为参数参数是值和键值对结合的方式(值必须写在最前面,且按照顺序)  
所以这样接受，能接受任意和任何类型的参数

#### 3.传参的时候,可以用 * 将序列拆开,用 ** 将字典拆开
```python
  def add(a,b):
    return a+b
  alist=[10,20]
  adict={'a':1,'b':2}
  add(*alist)
  add(**adict)
```

#### 4.如果需要在局部改变全局变量,使用global关键字
```python
  def func():
    global x
    x=1000       //则全局的变量x就会变为1000
```
***
### 装饰器
#### 1.基本装饰器
**python装饰器本质上将一个函数输入另一个函数里，然后返回一个新的函数出来**

```python
#装饰器，必须接受函数地址作为参数
def wrapper(func):

    #定义一个新的函数,用来接收被修饰函数的任意参数
    def func_new(*args, **kargs):

        #可以使用旧的函数不是必须
        pass

    #返回这个新的函数    
    return func_new

#@后面跟可以是任何内容，只要返回的是函数的地址即可
#下面等价于：
#   func_test = wrapper(func_test)
@wrapper
def func_test():
    pass
```
#### 2.带参数的装饰器
```python
def wrapper_out():
    def wrapper(func):
        def func_new(*args, **kargs):
            pass
        return func_new
    return wrapper

@wrapper_out()
def func_test():
    pass
```
#### 3.多个装饰器装饰一个函数def wrap1(func):
```python
def wrapper01(func):
    func_new(*args, **kwargs):
        pass
    return func_new

def wrapper02(func):
    func_new(*args, **kwargs):
        pass
    return func_new

#下面的内容等价于：
#   func_test = wrapper01(wrapper02(func_test))
@warpper01
@wrapper02
def func_test():
    pass
```

#### 4.demo
```python
def wrapper(func):    

    def func_new(*args,**kwargs):
        ret = func('old')              
        print(args)
        return ret

    return func_new         

@wrapper                  
def func_test(name):
    return name

result = func_test('1','2','one')

#结果为
#('1','2','one')
#result = 'old'
```
***
### 常用函数
#### 1.生成序列数（返回的是一个可迭代对象）
```python
range(n)          #不包含最后一个数,默认从0开始
range(n,m)
```
#### 2.匿名函数:用lambda声明
```python
  f=lambda x:x+10       #f(1)返回11
  f=lambda x,y:x+y      #f(1,2)返回3
```

#### 3.filter函数(用于过滤数据)
```python
#第一个参数是函数,返回值必须是True或False
#第二个参数是序列对象
#把序列对象中的每一个元素传递给函数,结果为True的保留
  nums=[11,22,33,44,55,66,77,88,99]
  list(filter(lambda x:True if x>50 else False,nums))
  list(filter(lambda x:x%2,nums))   #过滤出奇数
```

#### 4.map函数(加工数据)
```python
#第一个参数是函数,用于加工数据
#第二个参数是序列
  list(map(lambda x:x*2,nums))
```
#### 5.偏函数(改造现有函数,将其一些参数固定下来,生成新的函数)
```python
  import functools
  def add(a,b,c,d,e):
    return a+b+c+d+e
  functools.partial(add,10,20,30,40)  //将add的前4个参数固定下来

#改造int函数
  int2=functools.partial(int,base=2)
  int8=functools.partial(int,base=8)
```

***

### 递归函数
#### 1.基本概念
* 递归函数：函数调用自身
* 最大递归深度是1000层，超过1000层，就会抛出RecursionError的异常
* 限制最大递归深度的原因：为了节省内存空间，避免用户无限使用内存空间
* 尽量不要使用递归函数
#### 2.递归函数的特点
* 在调用前，必须设置一个停止条件
* 如果需要获取停止的返回值，则必须return func(xx)

***

### 闭包
#### 1.定义
只能存在**嵌套函数**中，**内层函数**对**外层函数** **非全局变量**的**使用**
#### 2.特点
* 保证数据的安全
* 被使用的非全局变量 被称为 **自由变量**
* 自由变量会跟内层函数产生绑定关系，即当外层函数终止了，自由变量不会消失
* 保存当前的运行环境
#### 3.demo
```python
def wrapper(a,b):
  def inner():
    print(a)
  return inner
```
```python
def wrapper():
  a = 1
  def inner():
    print(a)
  return inner
```

***

### 回调函数
通过函数指针（地址）调用的函数
callback意思就是留下地址，然后进行回电话，回调函数本质也是这样，通过函数地址调用函数
```python
def sum(a, b):
    return int(a) + int(b)


def compute(a, b, func):
    return func(a, b)

result = compute(1, 2, sum)    #这里的sum就是回调函数
```
