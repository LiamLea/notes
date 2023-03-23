
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [1.去除列表中的空行(包括'','    '之类的元素)](#1去除列表中的空行包括-之类的元素)
- [2.使用列表时，避免IndexError错误](#2使用列表时避免indexerror错误)
  - [（1）利用if进行判断](#1利用if进行判断)
  - [（2）捕获异常进行处理](#2捕获异常进行处理)
  - [（3）继承list类，创建一个新的list类](#3继承list类创建一个新的list类)
- [3.多个文件共享同一个全局变量](#3多个文件共享同一个全局变量)
- [4.python项目的组织形式](#4python项目的组织形式)
- [5.import包、函数等注意事项](#5import包-函数等注意事项)

<!-- /code_chunk_output -->

#### 1.去除列表中的空行(包括'','    '之类的元素)
```python
[ i for i in my_list if i.strip() != '' ]
```

#### 2.使用列表时，避免IndexError错误
##### （1）利用if进行判断
当发生IndexError概率比较大时

##### （2）捕获异常进行处理
当发生IndexError概率比较小时

##### （3）继承list类，创建一个新的list类
当程序中需要多次使用list[n]这种方式取值时
需要将list对象转换成自己编写的list对象
```python
class MyList(list):
    def __getitem__(self, y):
        try:
            return super(MyList, self).__getitem__(y)
        except IndexError:
            return ""

temp_list = MyList([0,1,2])
#接收的参数是一个可迭代对象
#不能这样创建列表 temp_list = [0,1,2]

print(temp_list[3])
#输出结果为空，不会报错
```

#### 3.多个文件共享同一个全局变量
**最好的方式是用一个文件单独放置全局变量，然后`import <FILE>`，通过`<FILE>.<VAR>`使用该变量**
```python
#file1.py

global a
```
注意：不能直接import这个变量，因为此时这个变量可能还没有被赋值
```python
#正确的使用方法

import file1

file1.a = 1
```

#### 4.python项目的组织形式
```shell
项目名

  lib
    utils         #存放一些工具函数和工具类
    common        #存放通用的方法和类（比如Base类）
    modules       #存放模块
    vars          #存放全局变量等
    plugins       #存放插件

  settings.py
  xx.py  
```

#### 5.import包、函数等注意事项
* 不能导入未定义的内容
  * 所以当循环import时就会出问题（导入b，b导入c，c导入a）
* `from lib.demo import test`
  * 虽然只导入test，但是还是会执行demo这个模块（如果demo是包的话，会执行`__init__.py`）
