# pandas

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [pandas](#pandas)
    - [概述](#概述)
      - [1.pandas](#1pandas)
      - [2.支持从多种格式中读取数据](#2支持从多种格式中读取数据)
      - [3.基础概念](#3基础概念)
        - [(1) index和columns](#1-index和columns)
    - [使用](#使用)
      - [1.Series](#1series)
        - [(1) Series的创建](#1-series的创建)
        - [(2) index和values](#2-index和values)
        - [(3) 基本属性和方法](#3-基本属性和方法)
        - [(4) 运算](#4-运算)
      - [2.DataFrame](#2dataframe)
        - [(1) DataFrame的创建](#1-dataframe的创建)
        - [(2) 属性](#2-属性)
        - [(3) index和slice](#3-index和slice)
        - [(4) 运算](#4-运算-1)
      - [3.层次化索引](#3层次化索引)
        - [(1) 创建多层索引](#1-创建多层索引)
        - [(2) index和slice](#2-index和slice)
        - [(3) 索引的堆叠](#3-索引的堆叠)
      - [4.聚合](#4聚合)
        - [(1) 常用聚合函数](#1-常用聚合函数)
        - [(2) 分组](#2-分组)
      - [5.数据合并](#5数据合并)
        - [(1) concat](#1-concat)
        - [(2) append](#2-append)
        - [(3) merge (很重要)](#3-merge-很重要)
      - [6.数据加载和写出](#6数据加载和写出)
        - [(1) CSV数据](#1-csv数据)
        - [(2) excel表格](#2-excel表格)
        - [(3) mysql](#3-mysql)
    - [数据处理](#数据处理)
      - [1.基本处理](#1基本处理)
        - [(1) 过滤数据](#1-过滤数据)
        - [(2) 缺省值处理](#2-缺省值处理)
        - [(3) 重复值处理](#3-重复值处理)
      - [2.数据映射](#2数据映射)
        - [(1) replace](#1-replace)
        - [(2) map](#2-map)
        - [(3) 更改索引](#3-更改索引)
        - [(4) apply和applymap](#4-apply和applymap)
        - [(5) tansform](#5-tansform)
      - [3.异常值处理](#3异常值处理)
        - [(1) describe 和 info (查看统计信息和数据结构)](#1-describe-和-info-查看统计信息和数据结构)
        - [(2) drop](#2-drop)
        - [(3) unique](#3-unique)
        - [(4) query (按条件查询)](#4-query-按条件查询)
        - [(5) sort](#5-sort)
      - [4.分桶 (buckets)](#4分桶-buckets)
      - [5.时间序列](#5时间序列)
        - [(1) 时间戳](#1-时间戳)
        - [(2) 索引](#2-索引)
        - [(3) 常用方法](#3-常用方法)
        - [(4) 时区](#4-时区)
        - [(5) 使用](#5-使用)
    - [plot](#plot)
      - [1.折线图](#1折线图)
      - [2.柱状图](#2柱状图)
      - [3.直方图](#3直方图)
      - [4.饼图](#4饼图)
      - [5.散点图](#5散点图)
      - [6.面积图](#6面积图)
      - [7.箱形图](#7箱形图)

<!-- /code_chunk_output -->

### 概述

#### 1.pandas
提供二维表的分析能力

#### 2.支持从多种格式中读取数据
* csv（comma-separated values）

#### 3.基础概念

##### (1) index和columns

* index是行的索引
* columns是列的索引

***

### 使用

```python
import numpy as np
import pandas as pd
```

#### 1.Series
一维数据结构
* 是dict和list的结合
  * index就是key，默认为0,1,2,...，可以修改为任何类型的

##### (1) Series的创建

* lsit -> Series
```python
list1 = [11,12,15,66]
s1 = pd.Series(list1)
```

* dict -> Series

* 其他参数
```python
list1 = [11,12,15,66]

#指定索引和名字
s1 = pd.Series(list1, index=["a","b","c",12], name="test")
```

##### (2) index和values
```python
print(s1)
"""
0    11
1    12
2    15
3    66
dtype: int64
"""

print(s1.index)
"""
RangeIndex(start=0, stop=4, step=1)
"""

print(s1.values)
"""
array([11, 12, 15, 66])
"""

s1.index=["a","b","c",12]
s1['a']
print(s1)
"""
a     11
b     12
c     15
12    66
dtype: int64
"""
```

* 显示索引和隐式索引
  * 显示索引就是指定的索引
  ```python
  s1["b"]

  #建议使用loc，在dataframe中有区别
  s1.loc["b"]
  ```
  * 隐式索引 即使指定了索引还是可以通过`iloc`(integer location-based indexing)方法使用0,1,2,...
  ```python

  s1.iloc[0]
  s1.iloc[0:2]
  ```

##### (3) 基本属性和方法
```python
s1.shape  #形状
s1.size   #长度

s1.head()
s1.tail()

s2 = pd.Series({"a": 1, "b":2, "c": np.nan})
s2.isnull()
"""
a    False
b    False
c     True
dtype: bool
"""
s2.notnull()

#取出为空的内容
s2[s2.isnull()]

#去除为空的内容
s2[~s2.isnull()]
```

##### (4) 运算
* 对应索引的值进行运算
```python
s3 + s4
#如果对应索引没有值，则返回nan
#可以使用函数填充
s3.add(s4,fill_value=0)
```

#### 2.DataFrame

二维的Series

##### (1) DataFrame的创建

* dict -> dataframe
```python
#一个key-value就是一列，key是列名
df = pd.DataFrame({
    "name": ["liyi", "lier", "lisan"],
    "age": [11,23, 21]
})

#index设置行索引
df = pd.DataFrame({
    "name": ["liyi", "lier", "lisan"],
    "age": [11,23, 21]
},index=['A','B','C'])
```

* 二维数组 -> dataframe
```python
df = pd.DataFrame(
  np.random.randint(1,10,size=(3,4)),
  index=['A','B','C'],
  columns=['a','b','c','d']
  )
```

##### (2) 属性

```python
df.values   #二维数组
df.index    #行索引
df.columns  #列索引
df.shape    #形状
```

##### (3) index和slice

```python
#列索引
df['a']
df.iloc[:,0]

#行索引
df.loc['A']
df.iloc[0]
```

* 切片
  * 切片是先对行进行切片
```python
df[1:3]
#等价于
df.iloc[1:3]

df.loc[['A','B']]
```

##### (4) 运算
* 对应索引的值进行运算
```python
df3 + df4
#如果对应索引没有值，则返回nan
#可以使用函数填充
df3.add(df4,fill_value=0)
```

* 与Series运算
```python
#匹配行索引，匹配进行运算
df.add(s, axis=0)
```

#### 3.层次化索引

DataFrame和Series都可以设置多层索引
索引的表示用元组: `(<index_1>,<index_2>,...)`

##### (1) 创建多层索引

* 隐式构造

```python
data = np.random.randint(0,100,size=(6,6))
index = [
    ["i1","i1","i1","i2","i2","i2"],
    ["j1","j2","j3","j1","j2","j3"]
]
columns = [
    ["m1","m1","m1","m2","m2","m2"],
    ["n1","n2","n3","n1","n2","n3"]
]

df = pd.DataFrame(data,index=index,columns=columns)
```
![](./imgs/pandas_01.png)

* 显示构造
```python
#使用元组
index2 = [
    ("i1","j1"),("i1","j2"),("i1","j3"),("i2","j1"),("i2","j2"),("i2","j3")
]

pd.DataFrame(data,index=pd.MultiIndex.from_tuples(index2))

#使用笛卡积
index3 = [
    ["i1","i2"],
    ["j1","j2","j3"]
]

pd.DataFrame(data,index=pd.MultiIndex.from_product(index3))
```

##### (2) index和slice
```python
df.iloc[0,1]
df.loc[("i2", "j1"), 2]
```

##### (3) 索引的堆叠

将列索引变为最后一层行索引

```python
#将最后一层列索引变为最后一层行索引
df.stack()

#将第一层列索引变为最后一层行索引
df.stack(0)

#将最后一层行索引变为最后一层的列索引
df.unstack()

#填充为空的值
df.unstack(fill_value=0)
```

* 将最后一层列索引变为最后一层行索引
![](./imgs/pandas_02.png)

#### 4.聚合

##### (1) 常用聚合函数
* sum()
```python
#默认axis=0，对行这个方向求和，即求每列的和
df.sum(axis=0)

#求所有元素的和
df.values.sum()
```

* count()
  * 非空的元素数量
* max()
* mix()
* median()
* mean()
* std()
* var()
  * 方差
* cov()
  * 协方差
  ```python
  #第0列和第1列之间的协方差
  df[0].cov(df[1])
  ```
* corr()
  * 相关系数(0-1)
* value_counts()
  * 统计每个元素的出现次数（默认是按列进行统计）
* cumsum()
  * 累加
* cumprod()
  * 累乘
* agg()
  * 执行多种聚合操作

##### (2) 分组

* 使用索引分组
```python
#使用第一层索引进行分组，然后再聚合
df.groupby(level=0).sum()
```

* 使用列进行分组
```python
df.groupby(by='age')
```

* 查看分组情况
```python
df.groupby(by='age').groups
```

#### 5.数据合并

##### (1) concat
```python
#增加行，如果列的索引不配，会错开
pd.concat([df1,df2],axis=0)

#合并方向上：不保留原来的索引，使用新的索引0,1,2,...
pd.concat([df1,df2],ignore_index=True)

#合并后加一层索引，给df1数据加一层x索引，给df2数据加一层y索引
pd.concat([df1,df2],keys=['x','y'])

#默认是外连接outer
#内连接，显示交集
pd.concat([df1,df2],join='inner')
```

##### (2) append
```python
df1.append(df2)
```

##### (3) merge (很重要)

* 相同索引的列，值相同，就合并行
  ```python
  #相同索引的列，值相同，就合并行，从而得到一个列更多的行
  df1.merge(df2)
  ```

  * 一对一
  ```python


  df1 = pd.DataFrame({
      "id": [1,2,3,4],
      "name": ["liyi","lier","lisan","lisi"],
      "age": [11,13,11,10]
  })

  df2 = pd.DataFrame({
      "id": [2,3],
      "score": [99,77]
  })
  df1.merge(df2)
  ```
  ![](./imgs/pandas_03.png)

  * 多对多
  ```python
  df1 = pd.DataFrame({
      "id": [1,2,2,4],
      "name": ["liyi","lier","lisan","lisi"],
      "age": [11,13,11,10]
  })

  df2 = pd.DataFrame({
      "id": [2,2],
      "score": [99,77]
  })
  pd.merge(df1,df2)
  ```
  ![](./imgs/pandas_04.png)

* 指定列的值相同就合并: on
```python
df1.merge(df2,on=["id"])
```

* 不同列的值相同就合并: left_on, right_on
```python
df1.merge(df2, left_on=["id"], right_on=["id2"])
```

* 将行索引也看成一列
```python
df1.merge(df2, left_index=True, right_index=True)
df1.merge(df2, left_index=True, right_on=["id2"])
```

* 外连接、左外、右外
```python
#默认为内连接
#outer、left、right
df1.merge(df2, how='inner')
```

* 合并后，列名冲突
```python
#在冲突的列名后添加后缀
df1.merge(df2,on=["id"],suffixes=['_df1','_df2'])
```

#### 6.数据加载和写出

##### (1) CSV数据

* 加载
```python
#header=[0,1]表示第1和2行 为列索引
#index_col=[0,1]表示第1和2列 为行索引
df = pd.read_csv(<path>, delimiter=',',header=[0,1],index_col=[0,1])
```

* 写出
```python
#header=True是否保留列索引
#index=False是否保留行索引
df.to_csv(<path>, delimiter=',', header=True, index=False)
```

##### (2) excel表格

* 加载
```python
#默认sheet_name=0，读取第一个sheet
#names=[]，替换列名
df = pd.read_excel('a.xlsx',sheet_name="Sheet2")
```

* 写出
```python
#后缀名为.xlsx
df.to_excel("a.xlsx")
```

##### (3) mysql

* 首先连接数据库

```python
#pip install sqlalchemy
#pip install pymysql

from sqlalchemy import create_engine

engine = create_engine(
    "mysql+pymysql://root:cangoal@10.10.10.163:58176/blade?charset=utf8"
)
```

* 加载
```python
df=pd.read_sql(
    sql="select * from blade_client",
    con=engine
)
```

* 写出
```python
df.to_sql(
  name="table",
  con=engin,
  index=False
)
```

***

### 数据处理

#### 1.基本处理

##### (1) 过滤数据
```python
#过滤不存在空值的行
cond = df.isnull().any(axis=1)
df[~cond]

#过滤不存在空值的列
cond = df.isnull().any()
df[:,~cond]
```

##### (2) 缺省值处理

* 两种空值
  * None
    * python自带的，效率低，不建议使用
    * 在pandas等函数中，会自动将None转换为np.nan
  * np.nan

* 判断空值
```python
df.isnull()
df.notnull()

#找到有空值的列
df.isnull().any()

#找到有空值的行
df.isnull().any(axis=1)

#找到全为空值的列
df.isnull().all()
```

* 删除空值
```python
#删除有空值的行
#inspace=False，不覆盖原来的数据，而是拷贝一份新数据，然后进行drop
df.dropna()

#删除全为空值的行
df.dropna(how='all')

#删除有空值的列
df.dropna(axis=1)
```

* 填充空值
```python
fillna(value=<value>)

#使用同列的前一个值进行填充
fillna(method="ffill")

#使用同行的前一个值进行填充
fillna(method="ffill", axis=1)
```

##### (3) 重复值处理

* 判断是否有重复
```python
#判断是否有重复的行
#比如第1行和第2行，重复，第1行为False，第2行为True
df.duplicated()

#判断是否有重复的行
#从后往前比较
#比如第1行和第2行，重复，第1行为True，第2行为Flase
df.duplicated(keep='last')

#判断是否有重复的行
#标记所有重复的行
#比如第1行和第2行，重复，第1行为True，第2行为True
df.duplicated(keep=False)

#判断id这列值重复的行
df.duplicated(subset=["id"])
```

* 删除重复行
```python
df.drop_duplicates()
```

#### 2.数据映射

##### (1) replace
```python
df.replace([<old_value>:<new_value>])
```

##### (2) map
只能处理一维数据
```python
df['age'].map(lambda x: x*10)
```

##### (3) 更改索引
```python
#更改行索引名
df.rename({<old_name>: <new_name>})

#更改列索引名
df.rename({<old_name>: <new_name>}, axis=1)

#重置行索引
df.reset_index()

df.reset_index(['a','b','c'])
```

##### (4) apply和applymap
* apply对于Series和map一样
* apply对于DataFrame是一行或一列作为输入
```python
#求每一列的平均值
df.apply(lambda x: x.mean(),axis=0)
```

* applymap对每一个元素进行map
```python
#每个元素*10
df.applymap(lambda x: x*10)
```

##### (5) tansform
与apply类似，能够执行多个函数，从而产生多列
```python
#对于Series
df['age'].transform(lambda x: x*10, lambda x: x*20)

#对于dataframe
df.transform(lambda x: x.mean(),lambda x: x.sum())
```

#### 3.异常值处理

##### (1) describe 和 info (查看统计信息和数据结构)

* 统计信息
```python
#对每列的数据进行统计
df.describe()

#对结果进行转置，方便查看
df.describe().T
```

* 标准差
```python
df.std()
```

* 数据结构
```python
df.info()
```

##### (2) drop
```python
#删除第一行
df.drop([0])
```

##### (3) unique
只能处理Series
```python
df['age'].unique()
```

##### (4) query (按条件查询)
```python
#查找符合条件的行
df.query('age > 10')

df.query('age in [20,21,23]')

n=10
df.query('age > @n')

ages = [20,21,23]
df.query('age in @ages')
```

##### (5) sort
```python
#按照age这列，对行进行排序
df.sort_values(['age'])

#安装行的索引进行排序
df.sort_index()
```

#### 4.分桶 (buckets)

```python
#根据age这个列的数据 对行进行分桶
#分为三个桶(0,20],(20,50],(50,100]
#桶名分别为: youth,adult,old
pd.cut(
  df['age'],
  bins=[0,20,50,100],
  labels=["youth","adult","old"]
)
```

* 等分
```python
#分成3等分
pd.qcut(
  df['age'],
  q=3
)
```

#### 5.时间序列

##### (1) 时间戳

下面生成的时间都是时间戳，只是显示格式不一样

* 时刻数据
```python
pd.Timestamp("2023.11.12")
#Timestamp('2023-11-12 00:00:00')

#生成连续的4个时刻
pd.date_range('2023.11.12',periods=4)
#DatetimeIndex(['2023-11-12', '2023-11-13', '2023-11-14', '2023-11-15'], dtype='datetime64[ns]', freq='D')
```

* 时期数据
```python
#显示到天
pd.Period("2023.11.12",freq="D")
#Period('2023-11-12', 'D')

#生成连续的4个时期
pd.period_range('2023.11.12',periods=4,freq='D')
#PeriodIndex(['2023-11-12', '2023-11-13', '2023-11-14', '2023-11-15'], dtype='period[D]')
```

##### (2) 索引

```python
#生成索引
index = pd.date_range('2023.11.12',periods=100)

#创建序列（索引为时间戳）
ts = pd.Series(np.random.randint(0,100,len(index)),index=index)
```

* 索引和切片
```python
ts['2024']    #获取2024年的数据
ts['2023-11-13':'2023-11-20']
ts[pd.Timestamp('2024-02-18')]
```

* 属性
```python
ts.index

ts.index.year
ts.index.month
ts.index.dayofweek    #星期几
```

##### (3) 常用方法

* 对整体数据的时间进行偏移
```python
#数据的时间增加2天
#由于索引不够，所以最后两条数据就不存在了
ts.shift(periods=2)

#数据的时间减少2天
ts.shift(periods=-2)
```

* 按照指定频率显示数据
```python
#显示每隔一周的数据
ts.asfreq(pd.tseries.offsets.Week())

#显示每小时的数据
ts.asfreq(pd.tseries.offsets.Hour())
```

* resample
```python
#每两天的数据做一次聚合
ts.resample('2D').sum()

df.resample('2M',on='time').sum()
```

##### (4) 时区
* 设置时区
```python
ts = ts.tz_localize(tz='UTC')
```

* 时区转换
```python
ts.tz_convert(tz='Asia/Shanghai')
```

##### (5) 使用

* 从外部导入文件
* 将时间列变为时间戳
```python
df['date']=pd.to_datetime(df['date'])
```
* 将时间戳设为行索引
```python
df.set_index(keys='date', inplace=True)
```

***

### plot

* plot的通用参数
```python
#设置图的大小
figsize=(18,18)
```

#### 1.折线图

```python
#一条折线
#s是Series
s.plot()

#多条折线
#x轴就是行的index，一列就是一条折线
df = pd.DataFrame(np.random.randint(0,100,size=(6,6)),columns=['a','b','c','d','e','f'])
df.plot()
```

* 当index足够多，间距足够小且连续时，就能画出平滑的曲线
```python
x = np.arange(0,2*np.pi,0.1)
y=np.sin(x)
s = pd.Series(data=y,index=x)
s.plot()
```

#### 2.柱状图
```python
#x轴就是行的index，一列就是一个柱形
df.plot.bar()

#堆叠：在同一个柱形上进行划分
df.plot.bar(stacked=True)

#水平的
df.plot.barh()
```

#### 3.直方图

统计数据出现的次数
* 看起来跟柱状图很像，表达的意思却截然不同
* 对于dataframe，取其中一列

```python
#x轴是数据
#y轴是数据出现的频次

s.plot.hist()

#会在直方图的基础上加一条趋势线
s.plot.kde()
```

#### 4.饼图

* 对于dataframe，取其中一列
```python
#autopct='%.1f%%'显示百分比
s.plot.pie(autopct='%.1f%%')

#画出dataframe的所有列
df.plot.pie(subplots=True)
```

#### 5.散点图
用于描述两列之间的关系

```python
df.plot.scatter(x='列名',y='列名')
```

#### 6.面积图
跟折线图类似，只不过对区域进行了填充
```python
df.plot.area()
```

#### 7.箱形图
```python
#从上到下：最大值，处在在75%的值，中间值，处在25%的值，最小值
df.plot.box()
```