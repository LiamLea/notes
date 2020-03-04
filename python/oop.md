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

#### 4.类的magic方法(以双下划线开始的)
```python
class A:
  def __init__(self,参数):      #构造函数
      pass

  def __str__(self):          
  #当对象需要转换成字符串时,自动执行这个函数
      return  'xx'
#如: a=A()
#print(a)，此时会返回xx

  def __call_(self):    
  #当对象执行调用时,自动执行这个函数
      pass
#如: a=A()
#a()，此时会执行...处的代码
```
#### 5.类的私有属性和函数
>两个下划线开头，声明该属性为私有，不能在类的外部被使用或直接访问，不能被子类继承
**__attrs**  
**__func**  

#### 6.重写父类的方法
**注意重写和覆盖的区别**
* 重写：比如父类有一个A方法和B方法，B方法会调用A方法，在子类中重写了A方法，则子类调用B方法时，B调用的就是重写后的A方法
* 覆盖：子类调用B方法时，B调用的还是以前的A方法
