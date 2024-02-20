# numpy


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [numpy](#numpy)
    - [概述](#概述)
      - [1.数组的维度和矩阵的维度](#1数组的维度和矩阵的维度)
    - [使用](#使用)
      - [1.基本数据结构: ndarray (n-dimension array)](#1基本数据结构-ndarray-n-dimension-array)
        - [(1) shape (描述数据的维度)](#1-shape-描述数据的维度)
        - [(2) 相关属性](#2-相关属性)
        - [(3) 创建ndarray](#3-创建ndarray)
        - [(4) 索引和切片](#4-索引和切片)
        - [(5) 对ndarray进行reshape](#5-对ndarray进行reshape)
        - [(6) 级联](#6-级联)
        - [(7) 拆分](#7-拆分)
      - [2.空值: nan](#2空值-nan)
      - [3.常用聚合函数](#3常用聚合函数)
      - [4.矩阵运算](#4矩阵运算)
        - [(1) 基本运算](#1-基本运算)
        - [(2) dot、cross、matrix multiply](#2-dot-cross-matrix-multiply)
        - [(3) 矩阵转置（transpose）](#3-矩阵转置transpose)
        - [(4) 矩阵其他运算](#4-矩阵其他运算)
      - [5.broadcasting (广播机制)](#5broadcasting-广播机制)
      - [6.写入文件和读取文件](#6写入文件和读取文件)

<!-- /code_chunk_output -->

### 概述

#### 1.数组的维度和矩阵的维度

* 矩阵是一个**二维**的数组
    * **一列**看成**一个向量**，所以**行数**就是矩阵的**维度**

* 数组的维度
    * 一个**数组**看成一个**轴（axis）**
        * **索引**就是在**轴上的坐标位置**，**数据**就是**轴上的一个点**

***

### 使用

```python
import numpy as np
```

#### 1.基本数据结构: ndarray (n-dimension array)

* ndarray中所有元素的类型都相同

##### (1) shape (描述数据的维度)
* `shape=(4,)`
    * 一维，有3个元素
* `shape=(4,2)`
    * 二维
    * 第一维有2个一维数据
    * 每个一维数据有3个元素
* `shape=(5,4,2)`
    * 三维
    * 第一维有5个二维数据
    * 每个二维数据中中有4个一维数据
    * 每个一维数据中有 2个元素

##### (2) 相关属性

```python
#获取shape
n.shape

#获取维度
n.ndim

#获取总的元素个数
n.size

#获取元素的类型
n.dtype
```

##### (3) 创建ndarray

* list -> ndarray

```python
#如果list中的元素类型不相同，会进行转换（优先级: str > float > int）
n = np.array(<list>)
```

* 创建所有元素都一样的ndarray
    * 创建元素都为1的ndarray
    ```python
    # arg1: 该ndarray的shape
    # arg2: 每个元素的类型
    # arg3: C：以行的顺序存储数据，F：以列的顺序存储数据
    n = np.ones((3,),np.int16, "C")
    ```

    * 创建元素都为0的ndarray
    ```python
    n = np.zeros((3,),np.int16, "C")
    ```

    * 创建元素都为<x>的ndarray
    ```python
    n = np.full((3,), "aaa")
    ```

* 创建主对角线都为1的ndarray
```python
#可以设置偏移
n = np.eye(6,6)
```

* 创建随机ndarray

    * 在一定范围内随机
    ```python
    #size就是ndarray的形状
    n = np.random.randint(1,10,size=(4,3))
    ```

    * 满足标准正太分布
    ```python
    n = np.random.randn(4,3)
    ```

    * 满足正太分布
    ```python
    #arg1: 均值
    #arg2: 标准差
    n = np.random.normal(100, 1,size=(3,4))
    ```

    * 0-1随机
    ```python
    n = np.random.random((3,4))
    ```

* 其他
    * 创建等差数列
        ```python
        n = np.linspace(0,10,6)
        #array([ 0.,  2.,  4.,  6.,  8., 10.])
        ```
        * arange
        ```python
        n = np.arange(1,10,2)
        ```

##### (4) 索引和切片
和list的用法一样，只不过多维度

```python
#取索引为3的行，然后在结果中取索引为4的行，然后在结果中索引为1的行
n[3][4][1]

#取 索引为的3行,索引为的4列 的 索引为1的元素
n[3,4,1]

#取第一维的第索引为1-4的数据
n[1:4]

#取第一维的第索引为1,4,2的数据
n[[1,4,2]]

#取索引1-3行的0-2列
n[1:3,0:2]
#取索引1-3行，然后在结果中在取0-2行
n[1:3][0:2]
```

* 倒置
    * 对行和列做倒置
    ```python
    n[::-1,::-1]
    ```

##### (5) 对ndarray进行reshape

* 数据量不会变量
    * 比如将一维结构变为2维结构，不会增加和减少数据
```python
a = list(range(0,20))
n = np.array(a)

n.reshape(4,5)
```

* 不明确指定行或列
```python
#转换为4行的二维数组
n.reshape(4,-1)

#转换为4列的二维数组
n.reshape(-1,4)
```

##### (6) 级联
```python
n1 = np.random.randint(1,100,(5,4,3))
n2 = np.random.randint(1,100,(5,4,3))

# axis=0表示在第一维度合并（如果垂直方向为0轴，即垂直方向上进行合并，即对每列进行合并）
# axis=1表示在第二维度合并（如果水平方向为1轴，即水平方向上进行合并，即对每行合并）
n3 = np.concatenate((n1,n2),axis=0)
#axis=0等价于
n3 = np.r_[n1,n2]
#axis=1等价于
n3 = np.c_[n1,n2]
```

##### (7) 拆分
```python
#arg1: 待拆分ndarray
#arg2: 怎么拆分，可以指定数字（即平均拆分）
#arg3: 在哪个维度进行拆分
np.split(n3,2,axis=0)

#或者索引列表（按照索引拆分）
#下面是将行分为3分
np.split(n3,[1,2],axis=0)
```

#### 2.空值: nan

#### 3.常用聚合函数

* 求和
```python
#整体求和
np.sum(n)

#对第一维度的数据求和
# 比如二维数组，如果垂直方向为0轴，即垂直方向上进行求和，即对每列进行求和）
np.sum(n, axis=0)

#对第二维度的数据求和
# 比如二维数组，如果水平方向成1轴，即水平方向上进行求和，即对每行进行求和）
```

* 排除空值求和
```python
np.nansum(n)
```

* 其他
```python
np.max(n)
np.min(n)
np.average(n)
np.median(n)
np.percentile(n,90)    #求处在90%这个水平的数

#找到最大的数，返回下标（该下标为将矩阵转换为一维矩阵时的下标）
np.argmax(n)
np.argmin(n)
#找出满足条件的下标
np.argwhere(n==np.max(n))

#将原来的某个元素进行三次方运算
np.power(n,3)
#或者
n**3

#标准差
np.std(n)
#方差
np.var(n)
```

#### 4.矩阵运算

##### (1) 基本运算
```python
n + 10
n - 10
n * 10
n / 10
n // 10 #整除
n ** 2
n % 2

n1 + n2 #对应的元素相加
n1 * n2 #对应的元素相乘
```

##### (2) dot、cross、matrix multiply

* dot product对象：**向量**，**输出**是一个**值**
* matrix multiply对象：**矩阵**，**输出**是另一个**矩阵**

```python
# dot（向量间运算）
np.dot(n1,n2)

# matrix multiply
np.matmul(X1, X2)
#或者
n1@n2

# cross
np.cross(X1,X2)
```

##### (3) 矩阵转置（transpose）
指将一个矩阵的行和列互换得到的新矩阵
```python
a = np.array([[1, 2], [3, 4]])
a.transpose(1, 0)
或者
a.T
```

##### (4) 矩阵其他运算

```python
#矩阵逆
np.linalg.inv(n)

#矩阵行列式
np.linalg.det(n)

#矩阵的秩
np.linalg.matrix_rank(n)
```

#### 5.broadcasting (广播机制)
如果对两个数组实施加、减、乘、除等运算时
* 补充缺失的维度
* 使用已有数值进行填充

#### 6.写入文件和读取文件

```python
#将一个ndarray写入文件
np.save("a.npy", <ndarray>)

#读取文件
nw1 = np.load("a.npy")

#将多个ndarray写入文件
np.save("a.npz", <k1>=<ndarray1>, <k2>=<ndarray1>)
#读取文件
nw2 = np.load("npz")
nw2[<k1>]
```

* 存储为txt格式
    * 只能是一维或二维的数组
```python
np.savetxt("a.csv",n4,delimiter=",")
nw4 = np.loadtxt("a.csv",delimiter=",")
```

