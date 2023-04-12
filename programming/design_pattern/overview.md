# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.设计原则概述](#1设计原则概述)
        - [(1) 目标](#1-目标)
        - [(2) 思路](#2-思路)
        - [(3) 以计算器为例](#3-以计算器为例)
      - [2.设计原则（S.O.L.I.D.）](#2设计原则solid)
        - [(1) DIP详细说明](#1-dip详细说明)
      - [3.对象的四种关系](#3对象的四种关系)
    - [设计模式](#设计模式)
      - [1.factory](#1factory)
        - [(1) simple factory](#1-simple-factory)
        - [(2) factory method](#2-factory-method)
        - [(3) abstract factory](#3-abstract-factory)
      - [2.strategy](#2strategy)
      - [3.decorator](#3decorator)
      - [4.proxy](#4proxy)

<!-- /code_chunk_output -->

### 概述

#### 1.设计原则概述

##### (1) 目标
* 可维护
* 可复用
* 可扩展
* 灵活性好

##### (2) 思路
通过封装、继承、多态 **降低耦合度**


##### (3) 以计算器为例
* 创建一个运算类
    * 加、减等都继承该运算类
* 创建一个工厂类
    * 根据参数，返回相应的运算类

#### 2.设计原则（S.O.L.I.D.）

|原则 (S.O.L.I.D.)|说明|好处|
|-|-|-|
|SRP: single responsibility principle|单一职责|便于维护、复用，灵活性更好|
|OCP: open-close principle|对扩展开放，对修改封闭|有新的变化，只需要进行添加，而无须修改（比如计算器，抽样出一个运算类，有新的运算直接扩展就行了，无需修改）|
|LSP: liskov substitution principle|子类型必须能够替换掉他们的父类型（即当声明的类型是 父类，可以传入 子类实例）|是DIP、OCP的基础|
|**DIP**: dependency inversion principle|高层模块不应该依赖低层模块，两者都应该依赖抽象（即接口或抽象类）</br>抽象不应该依赖细节，细节应该依赖抽象|是面向对象的标志|

##### (1) DIP详细说明
* 为什么叫依赖倒置
    * 以前是高层依赖低层，倒置后，两者都依赖抽象
* 举例: 有一个Copier class，需要从keyboard读取输入，打印到printer
    * 高层依赖低层的设计模式
    ![](./imgs/overview_02.png)
        * 代码
            ```java
            public class Copier{
                private readonly Keyboard _keyboard;
                private readonly Printer _printer;

                public Copier(Keyboard keyboard, Printer printer){
                    _keyboard = keyboard;
                    _printer = printer;
                }


                public void Copy(){
                    int c = _keyboard.Read();
                    while(!_keyboard.IsEndingCharacter(c)){
                        _printer.Write(c);
                        c = _keyboard.Read();
                    }
                }
            }
            ```
    * 都依赖抽象
    ![](./imgs/overview_03.png)
        * 代码
            ```java
            public class Copier{
                private readonly IReader _reader;
                private readonly IWriter _writer;

                public Copier(IReader reader, IWriter writer){
                    _reader = reader;
                    _writer = writer;
                }


                public void Copy(){
                    int c = _reader.Read();
                    while(!_reader.IsEndingCharacter(c)){
                        _writer.Write(c);
                        c = _reader.Read();
                    }
                }
            } 
            ```

#### 3.对象的四种关系

|对象关系|说明|
|-|-|
|dependcy|依赖关系，一个类的实现依赖另一个类的定义|
|association|关联关系，一个类的属性或方法与另一个类有关系|
|aggregation|较强的关联关系，整体与个体的关系，即整体可以没有这个个体|
|composition|更强的关系关系，整体与部分的关系，即整体不能没有这个部分|

***

### 设计模式

#### 1.factory

##### (1) simple factory
传入参数 -返回-> 一个实例

##### (2) factory method

##### (3) abstract factory

#### 2.strategy

* 说明
    * 分别封装算法，让他们之间可以相互替换，对使用算法的用户是透明的
![](./imgs/overview_01.png)

* 适用场景
    * 当算法不固定，且能够相互替换

#### 3.decorator

* 说明
    * 是为了添加更多 通用功能 的方式
    * 把类的 核心职责 和 装饰功能（某种特定情况下才需要的功能） 区分
* 适用场景
    * 当需要添加通用功能（不是针对某一个类）

#### 4.proxy

* 说明
    * 为对象的访问提供一种代理 以控制对这个对象的访问
* 适用场景
    * 远程代理
        * 为一个对象在 不同的地址空间中 提供一个局部代表（这样使用者就感觉对象跟它在一个地址空间中）
    * 虚拟代理
        * 代理实例化需要很长时间的对象，当未实例好时，返回一些假的内容来代替真实内容（比如浏览器： 当打开一个网页时，需要很长时间，浏览器会先将文字展示出来，图片一张一张显示）
    * 安全代理
        * 访问对象时进行一些写安全控制
    * 智能指引
        * 调用对象时，添加一些额外的功能


