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
