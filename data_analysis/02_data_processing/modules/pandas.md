# pandas

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [pandas](#pandas)
    - [概述](#概述)
      - [1.pandas](#1pandas)
      - [2.支持从多种格式中读取数据](#2支持从多种格式中读取数据)
    - [使用](#使用)
      - [1.Series](#1series)
        - [(1) Series的创建](#1-series的创建)
        - [(2) index和values](#2-index和values)
        - [(3) 基本属性和方法](#3-基本属性和方法)
        - [(4) 运算](#4-运算)
      - [1.读取数据](#1读取数据)
      - [3.使用数据](#3使用数据)

<!-- /code_chunk_output -->

### 概述

#### 1.pandas
提供二维表的分析能力

#### 2.支持从多种格式中读取数据
* csv（comma-separated values）

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

#### 1.读取数据
```csv
name , liyi , lier , lisan
math_score , 89, 72, 90
sport_score , 91, 99, 100
english_score , 88, 89, 91
```

```python
#默认engine为c语言，sep就不能使用正则（修改为python后可以）
#sep要去掉空格，不然后面使用的话也需要相应的空格
data = pandas.read_csv("<filename>", engine = "python", sep = r"\s*,\s*")
```

#### 3.使用数据

* 读取后生成的数据结构

|name|liyi|lier|lisan|
|-|-|-|-|
|math_score|89|72|90|
|sport_score|91|99|100|
|english_score|88|89|91|

* 使用该数据结构

```python
data["liyi"]    #获取liyi这一列，list(data["liyi"])：[89, 91, 88]

data.columns    #获取所有的列名，list(data.columns)：['name', 'liyi', 'lier', 'lisan']
data.col[0]     #获取第一行数据，list(data.col[0])：['math_score', 89, 72, 90]
```
