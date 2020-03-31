[toc]
# 函数
###基础
* **传参的方式**
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

* **使用参数组表示函数的形参**

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

* **传参的时候,可以用 * 将序列拆开,用 ** 将字典拆开**
```python
  def add(a,b):
    return a+b
  alist=[10,20]
  adict={'a':1,'b':2}
  add(*alist)
  add(**adict)
```

* **如果需要在局部改变全局变量,使用global关键字**
```python
  def func():
    global x
    x=1000       //则全局的变量x就会变为1000
```
###装饰函数
**python装饰器本质上将一个函数输入另一个函数里，然后返回一个新的函数出来**
```python
def func_a(func):           #装饰器，需要接受函数地址作为参数
    def func_new(*args,**kwargs):     
    #定义一个新的函数,用来接收被修饰函数的任意参数
        func()              #使用旧的函数不是必须
        print('new')
    return func_new         #返回这个新的函数

#下面等价于func_a(func_b)()
@func_a
def func_b(name):               
    print(name)

#结果为：
#b
#new
```
###常用函数
* 生成序列数（返回的是一个可迭代对象）
```python
range(n)          #不包含最后一个数,默认从0开始
range(n,m)
```
* 匿名函数:用lambda声明
```python
  f=lambda x:x+10       #f(1)返回11
  f=lambda x,y:x+y      #f(1,2)返回3
```

* filter函数(用于过滤数据)
```python
#第一个参数是函数,返回值必须是True或False
#第二个参数是序列对象
#把序列对象中的每一个元素传递给函数,结果为True的保留
  nums=[11,22,33,44,55,66,77,88,99]
  list(filter(lambda x:True if x>50 else False,nums))
  list(filter(lambda x:x%2,nums))   #过滤出奇数
```

* map函数(加工数据)
```python
#第一个参数是函数,用于加工数据
#第二个参数是序列
  list(map(lambda x:x*2,nums))
```
* 偏函数(改造现有函数,将其一些参数固定下来,生成新的函数)
```python
  import functools
  def add(a,b,c,d,e):
    return a+b+c+d+e
  functools.partial(add,10,20,30,40)  //将add的前4个参数固定下来

#改造int函数
  int2=functools.partial(int,base=2)
  int8=functools.partial(int,base=8)
```
