[toc]
# 序列
**序列：list,tuple,string**
**序列的实例是序列对象，都是可迭代对象**
**下面的seq代表序列对象**

* 序列对象相互转换（不会对原序列对象产生影响）
```python
  list(seq)        
  tuple(seq)
  str(obj)
  str([10,20,30])   #转换为:'[10,20,30]'  
```

* 序列对象翻转:
```python
  seq[::-1]            #这里必须是序列对象才能进行翻转或切割
```
* 排序:
```python
  sorted(seq)
```

* enumerate(seq)   

返回一个enumerate对象(枚举,获得下标和对应的值),可以将其转换为list等
```python
  a=[1,2,3,4,5]
  list(enumerate(a))
#结果：[(0, 1), (1, 2), (2, 3), (3, 4), (4, 5)]
```

# string
**因为字符串是不可变的,所以对字符串的改变,都是以返回值的形式**
* 格式化
```python
'%s' %str
'%d' %digit
'%s,%s' %(str1,str2)
'%10s' %str               #宽度为10,左对齐
'%-10s' %str              #宽度为10,右对齐
```
* 原始字符串
```python
str='c:\tmp\new'   #会进行转义（\t转换为制表符，\n转换为换行）
#解决:
str='c:\\tmp\\new'
#或者利用原始字符串
str=r'c:\tmp\new'
```

* 字符串函数
```python
#常用
str.strip()                 #去除两端的空白字符,能够去除换行符等
str.rstrip()                #能够去除换行符等
str.replace('xx','yy')
str.split()                 #默认以空格进行切割
str.split('x')              #默认以'x'进行切割
'xx'.join(列表等)
#如:'-'.join(['ni','hao'])   #输出 'ni-hao'
str.upper()
str.lower()
```
```python
str.center(10)              #居中,总宽度为10
str.center(10,'*')          #居中,总宽度为10,用*补全
str.ljust(10)               #居左
str.rjust(10)               #居右
str.lstrip()                #去除左端的空白字符
str.startswith('xx')        #如果以xx开头,返回True
str.endswith('xx')          #如果以xx结尾,返回True
```
# list
* 列表解析
```python
  [10+2 for i in range(5)]
  [10+i for i in range(5)]
  [10+i for i in range(5) if i%2==1]
```
* 列表函数
```python
  append(xx)
  extend(XX)            #将另一个列表接上去
  remove(xx)            #删除第一个xx元素
  index(xx)             #获得第一个xx元素的下标
  insert(index,xx)
  reverse()
  sort()                #升序排序
  sort(reverse=True)
  count(xx)             #统计元素为xx的个数
  pop()
  pop(<INDEX>)
  copy()
#blist=alist.copy() 和 clist=alist 区别:
#blist和alist指向不同的存储空间
#clist和alist指向相同的存储空间
```
* 排序
```python
#元组等不可以排序,因为是不可变对象
#字典也没有排序,需要转换成列表:list(adict.items())

xx.sort(cmp=None,key=None,reverse=False)   

#一般函数用lambda
#cmp指定了该参数会使用该参数的方法进行排序
#sort可以传入一个函数(即c++中的谓词), key=函数名
#该函数将列表中的每一项进行处理,处理的结果作为排序的依据
```
* 继承list，创建自己的list类
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
# tuple
**相当于静态的列表，查询函数与列表一致**
* 命名元组
相当于有属性的简单类
```python
from collections import namedtuple
Test = namedtuple("xx", "KEY1 KEY2 ...")
# 第一个参数是元组的名字，不重要
# 第二个参数是属性，用空格隔开
# 返回一个类，实例化这个类就相当于创建元组

#实列化
test = Test(VALUE1, VALUE2, ...)

#使用
test.KEY1
```
例子
```python
Car = namedtuple("color", "owner")
my_car = Car('red', 'lil')
print(my_car.color)
#输出为：red
```
# dict
**不可变的对象才可以作为key,如:字符串,数字,元组等**
* 生成字典的函数:dict
```python
  dict('ab',['c','d'],('e','f'))
#返回的字典:{'a':'b','c':'d','e':'f'}
```

* 生成值相同的字典的函数:{}.fromkeys
```python
  {}.fromkeys(['a','b','c'],20)
#返回的字典:{'a':20,'b':20,'c':20}
```

* **遍历字典**
```python
  for key in dict:
    print(key)

  for key,value in adict.items():
    print(key,value)
```

* 打印字典某些key的value
```python
  adict={'key1':'a','key2':'b','key3':'c'}
  print('%(key1)s,%(key3)s' %adict)
```

* 相关函数
```python
  keys()
  values()
  items()           #返回一个可迭代对象,每一个元素都是键值对,否则只能迭代key

  pop(<KEY>)          #返回<KEY>的值，并且把该<KEY>从字典中移除
  pop(<KEY>, <XX>)    #如果该<KEY>不存在，则返回<XX>

#合并两个字典
  <DICT>.update(dict)                #将另一个字典加上去
  dict = {**dictA, **dictB}   #如果有相同的key，第二个的值会覆盖第一个的

  get(<KEY>)          #若<KEY>不存在返回none(当需要判断key是否存在,用in即可)
  get(<KEY>, <XX>)       #若<KEY>不存在返回<XX>(可以是字符串,也可以是数字)
```

* 利用字典,根据条件执行相应的函数  
```python
#相当于case
  cmds={'key1':func1,'key2':func2}    #func后面不能加(),否则储的是函数的返回结果
  cmds[xx]()      #根据xx的值,执行相应的函数
```
# set
**集合元素必须是不可变对象,且不能重复**
**集合是无序的(跟字典一样)**

**经常使用集合实现 去重操作**

* 生成不可变集合的函数:frozenset(iter)
```python
  如:frozenset('abc')    #{'a','b','c'}，生成的集合不可变换（即无法添加删除）
```
* 生成可变集合的函数:set(iter)
```python
  如:set('abc')      #{'a','b','c'}
```
* 求交集:aset&bset

* 求并集:aset|bset

* 求差补:aset-bset
aset中有的,bset中没有的

* 相关函数
```python
  add(xx)
  remove(xx)
  update(set)
```
