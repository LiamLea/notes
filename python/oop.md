#OOP(object oriented program)
**在python中一切皆对象**
###基础
#### 1.定义一个类的基本格式
```python
class 类名:
  def __init__(self,参数):
    self.属性1=xx

  def func1(self):    
    print('%s' %self.属性1)

#类名采用大驼峰命名
#__init__是构造函数,在创建实例的时候自动调用
#所有方法的第一个参数必须是self,表示实例(可以用别的名字,java中是this)
#创建实例时,实例会自动作为第一个参数传入
```
#### 2.组合

**即将一个对象传入另一个对象中,就有了多级的对象**
```python
  class Weapon:
    def __init__(self,name,strength):
      self.name=name
      self.strength=100

  class GameRole:
    def __init__(self,name,weapon):
      self.name=name
      self.weapon=weapon

  ji=Weapon('方天画戟',100)
  lb=GameRole('吕布',ji)
  print(lb.weapon.name)   
#这里就有两级,输出的内容为"方天画戟"
```

#### 3.继承

**可以对父类的属性和方法进行重写**
```python
  class 类名(父类):
      pass
```

>重写构造函数:
```python
  def __init__(self,参数):
      父类.__init__(self,部分参数)
      #等价于:super(类名,self).__init__(部分参数)
          pass
```

>多重继承:   
```python
  class 类名(父类1,父类2):   
  #有相同的属性或方法时,优先继承左边父类的
      pass
```

#### 4.类的magic方法
```python
class A:
  def __init__(self,参数):      #构造函数
      pass

  def __str__(self):          
  #当对象需要转换成字符串时,自动执行这个函数
      return  'xx'
#如: a=A()
#print(a)，此时会返回xx

  def __call__(self):    
  #当对象执行调用时,自动执行这个函数
      pass
#如: a=A()
#a()，此时会执行...处的代码
```
#### 5.类的私有属性和函数
>两个下划线开头，声明该属性为私有，不能在类的外部被使用或直接访问，不能被子类继承
**__attrs**  
**__func**  

#### 6.类的 \_\_getattribute__ 方法
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

#### 7.重载（overload）和重写（override，覆盖）
