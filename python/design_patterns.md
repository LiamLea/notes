# design patterns（隔离稳定和变化）
[toc]
### 设计原则
#### 1.依赖倒置原则（DIP：dependency inversion principle）
* 高层模块不应依赖底层模块（变化），二者都应依赖抽象（稳定）
抽象是稳定的，底层模块一般是变化的，稳定的不应该依赖变化的
* 抽象（稳定）不应依赖实现细节（变化），实现细节应该依赖抽象
* 程序依赖于抽象接口，不要依赖于具体实现
#### 2.开放封闭原则（OCP：open close principle）
* 对扩展开放，多更改封闭
* 类模块应该是可扩展的，但是不可修改

#### 3.单一职责原则（SRP：single responsibility principle）
* 一个类应该仅有一个引起它变化的原因
* 变化的方向隐含着类的责任

#### 4.liskov替换原则（LSP：liskov substitution principle）
* 子类必须能够替换他们的基类（IS-A）
任何基类可以出现的地方，子类一定可以出现

#### 5.接口隔离原则（ISP：interface segregation principle）
* 接口应该小而完备
从而降低了对该接口的依赖性
* 一个类对另一个类的依赖应该建立在最小的接口上

#### 6.优先使用对象组合，而不是类继承
* 对象组合就是通过对现有的对象进行拼装（组合）产生新的、更复杂的功能
由于对象之间各自内部细节不对外可见，所以这种方式的代码复用被称为“黑盒式代码复用”(black-box reuse)。对象组合要求被组合的对象具有良好定义的接口。
* 继承在某种程度上破坏了封装性

#### 7.封装变化点
* 使用封装来创建对象之间的分界层，让设计者可以在分界层的另一侧进行修改

#### 8.针对接口编程，而不是针对实现编程
* 不将变量类型声明为某个特定的具体类，而是声明为某个接口（抽象类）

***

### 单例模式
#### 1.概述

设定某个类只能实例化一次
* 在建立连接时很有用（能够**共享**连接）

#### 2.实现

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

***

### Template Method（模板方法）
#### 1.概述
* 定义一个稳定的骨架，将变化延迟到子类（稳定中有变化）
#### 2.实现
* 类A要实现step1,step3,step5
* 类B要实现step2,step4
* 类A和类B需要协议，最终运行step1-5
```python
class A:
    def step1(self):
        pass
    def step2(self):
        pass
    def step3(self):
        pass
    def step4(self):
        pass
    def step5(self):
        pass

    def run():
        self.step1()
        self.step2()
        self.step3()
        self.step4()
        self.step5()

class B:
    def step2(self):
        pass
    def step4(self):
        pass


b = B()
b.run()
```
上面的实现采用的是晚绑定的方式，即先创建的方法需要绑定后创建的方法
如果在类B中实现run()函数，则就是早绑定方法，即后创建的方法需要绑定先创建的方法
晚绑定具有更好的灵活性和复用性

***

### Stragtegy（策略模式）
#### 1.概述
* 定义一系列算法，把他们封装起来，并且使他们可以相互替换
* 还有很多条件判断的语句（`if...else if...`），且这些条件是不稳定的（稳定的条件比如判断男女），都需要考虑stragtegy模式

***

### Observer（观察者模式）
#### 1.概述
#### 2.实现
