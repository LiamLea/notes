[toc]
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
```
项目名
  lib
    utils
    common
    modules
    plugins
  settings.py
  xx.py  
```
