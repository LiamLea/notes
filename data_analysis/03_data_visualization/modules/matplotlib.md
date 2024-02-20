# matplotlib


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [matplotlib](#matplotlib)
    - [基础](#基础)
      - [1.基础概念](#1基础概念)
        - [(1) dpi (dots per inch)](#1-dpi-dots-per-inch)
        - [(2) ppi (pixels per inch)](#2-ppi-pixels-per-inch)
        - [(3) resolution (分辨率)](#3-resolution-分辨率)
    - [使用](#使用)
      - [1.基本参数](#1基本参数)
        - [(1) 样式和颜色](#1-样式和颜色)
        - [(2) 画布设置](#2-画布设置)
      - [2.多图布局](#2多图布局)
        - [(1) 子图](#1-子图)
        - [(2) 双轴图](#2-双轴图)
      - [3.绘图属性](#3绘图属性)
        - [(1) legend (图例)](#1-legend-图例)
        - [(2) 线条属性](#2-线条属性)
        - [(3) 坐标轴](#3-坐标轴)
        - [(4) 标题、网格线、轴标签、文字](#4-标题-网格线-轴标签-文字)
        - [(5) 标注（有箭头）](#5-标注有箭头)
      - [4.常用视图](#4常用视图)
        - [(1) line chart (折线图)](#1-line-chart-折线图)
        - [(2) 柱形图](#2-柱形图)
        - [(3) 直方图](#3-直方图)
        - [(4) 箱型图](#4-箱型图)
        - [(5) 散点图](#5-散点图)
        - [(6) 饼图](#6-饼图)
        - [(7) 面积图](#7-面积图)
        - [(8) 热力图](#8-热力图)
        - [(9) 极坐标图](#9-极坐标图)
        - [(10) 雷达图](#10-雷达图)
        - [(11) 等高线图](#11-等高线图)
        - [(12) 3D图](#12-3d图)
    - [图片处理](#图片处理)
      - [1.基本处理](#1基本处理)

<!-- /code_chunk_output -->

### 基础

#### 1.基础概念

##### (1) dpi (dots per inch)
一般指图片生成设备在 **每英尺** 能够打印的**像素点**

##### (2) ppi (pixels per inch)
反映的是显示效果，在每英尺内的像素点
图片的大小（像素数）是一定的，显示的**物理大小**决定了ppi

##### (3) resolution (分辨率)

图片的大小（不是物理大小）: 水平像素数 * 垂直像素数

* 1080p = 1920 * 1080
* 2k = 2048 * 1080
* 4k = 4096 * 2160

***

### 使用

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
```

* 保存图片
```python
plt.savefig(<path>,figsize=(4,5), dpi=100)
```

#### 1.基本参数

```python
plot(x1,y1)
plot(x2, y2)
plot.show()

#默认都是画在一张图上
```

##### (1) 样式和颜色
```python
#color: c='r'使用红色
#line style: ls='--'使用虚线
plt.plot(..., c='r', ls='--')
```

##### (2) 画布设置
```python
plt.figure()

#参数:

#长宽（单位为: inch）
figsize = (4,5)

#dots per inch（即每英尺内的像素点）
dpi=100

#画布颜色
facecolor='r'

#设置网格
plt.grid()
```

#### 2.多图布局

##### (1) 子图
```python
#221: 2行2列 第1个放这个子图
ax1 = plt.subplot(221)
ax1.plot(x,y)
ax1.set_title('xxx')

#自动调整布局
plt.tight_layout()
```

* 更精确的设置子图的位置
```python
#[left,bottom,width,height]
#left和bottom用来描述子图间的相对位置
ax1 = plt.axes(1,1,1,1)
```

##### (2) 双轴图
比如两张图共享x轴,各自有自己的y轴
```python
ax1 = plt.gca()
ax1.plot(x,y)
ax2 = ax1.twinx()
ax2.plot(x,np.cos(x),c='r')
```

#### 3.绘图属性

##### (1) legend (图例)
```python
plt.plot(x,np.sin(x), label='sin')
plt.plot(x,np.cos(x), label='cos')
plt.legend()

"""
图例参数:
    字体大小: fontsize
    位置: loc
    显示几列: nloc
    具体位置: bbox_anchor
"""
```

##### (2) 线条属性
```python
"""
线条属性:
    线条颜色: color
    线条类型: ls
    线条宽度: lw
    线条透明度: alpha
    标记数据点: marker
    标记的颜色: mfc
    标记的线条颜色: markeredgecolor
    标记大小: markersize
"""
```

##### (3) 坐标轴

```python
#设置坐标轴刻度，0到11，步长为1
plt.xticks(np.arange(0,11,1))

"""
设置刻度的标签: labels
设置刻度的大小: fontsize
"""

#设置坐标轴的范围
plt.xlim(0,10)

#坐标轴的配置
plt.axis()

"""
参数:
    不显示坐标轴: off
    x和y轴刻度距离相同: equal
    调整坐标轴，自适应图片: scaled
"""
```

##### (4) 标题、网格线、轴标签、文字

```python
plt.title('title1')
plt.suptitle('父标题')

plt.grid()
"""
参数:
    只让某个方向显示网格线: axis
"""

plt.xlabel('x label')
plt.ylabel('y label', rotation=90)

plt.text(<x>,<y>,<text>)
```

##### (5) 标注（有箭头）
```python
plt.annotate(
    xy=(4,90),      #需要标注的点
    text='最高销量', #标注内容
    xytext=(1,80),  #标注内容的位置
    arrowprops={
        'width': 2
    }
)
```

#### 4.常用视图

##### (1) line chart (折线图)
```python
plt.plot(x,y)
```

##### (2) 柱形图
```python
plot.bar(x,y)
#水平方向
plot.barh(x,y)

#簇状柱形图
w=0.2
plt.bar(x-w,y1,width=w)
plt.bar(x,y2,width=w)
plt.bar(x+w,y3,width=w)

#堆叠柱状图
plt.bar(x,y1)
plt.bar(x,y2,bottom=y1)
plt.bar(x,y3,bottom=y1+y2)
```

##### (3) 直方图
统计数值出现的次数

```python
x = np.random.randint(0,10,100)
#pd.Series(x).value_counts()

plt.hist(x)

"""
分桶: bins
能够统计一定范围内的数值数量

显示概率分布: density=True
"""
```

##### (4) 箱型图
```python
"""
从上到下：
    最大值，处在在75%的值（Q3），中间值（Q2），处在25%的值（Q1），最小值
不在范围内的属于异常值:
    如果 > Q3+(Q3-Q1)*1.5
    如果 < Q1-(Q3-Q1)*1.5
"""

plot.boxplot(x)
```

##### (5) 散点图
数据点，分析两组数据可能存在的关系

```python
data = np.random.randint(0,100,size=(100,2))
s = np.random.randint(0,100,size=100)
c = np.random.randn(100)
plt.scatter(data[:,0],data[:,1], s=s, c=c)
```

##### (6) 饼图

```python
#显示数值的占比
#explode突出某一块区域
plt.pie([10,20,20,40], autopct='%.1f%%',labels=['A','B','C','D'],explode=[0,0.1,0,0])
```

* 空心
```python
#设置空心程度： wedgeprops={'width': 0.5}
plt.pie([10,20,20,40], autopct='%.1f%%',labels=['A','B','C','D'],wedgeprops={'width': 0.5})
```

* 空心圆内嵌套饼图
```python
plt.pie([10,20,20,40], autopct='%.1f%%',labels=['A','B','C','D'],wedgeprops={'width': 0.4})
plt.pie([10,20,20,40], autopct='%.1f%%',labels=['A','B','C','D'],radius=0.5)
```

##### (7) 面积图
```python
plt.stackplot(x,y)
```

##### (8) 热力图

跟表格一样，只是每个item不是数字，而是颜色（颜色深浅表示数值的大小）

```python
nd = np.random.randint(0,100,size=(20,5))
df = pd.DataFrame(nd,columns=['A','B','C','D','E'])
plt.figure(figsize=(5,20))
x = df.columns
y = df.index
plt.yticks(range(len(y)), y)
plt.xticks(range(len(x)),x)
plt.imshow(df)

for i in range(len(x)):
    for j in range(len(y)):
        plt.text(
            x=i,
            y=j,
            s=df.iloc[j,i]
        )

plt.colorbar()
plt.show()
```

##### (9) 极坐标图

```python
x = np.arange(0,10)
y = x ** 2

plt.subplot(111,projection='polar')
plt.bar(x=x,height=y)
```

##### (10) 雷达图
圆默认被分为8份，即当x=0和x=8时，是重合的
```python
x = np.linspace(0,2*np.pi,6, endpoint=False)
y = [80,60,2,40,77,99]

x=np.concatenate((x,[x[0]]))
y=np.concatenate((y,[y[0]]))

plt.subplot(111,polar=True)
plt.plot(x,y,'o-')
plt.fill(x,y,alpha=0.3)
```

##### (11) 等高线图
工作原理:

* 首先会将x,y划分成网格（一维数组x和y）
* 然后计算每个网格点的值（二维数组z）
* 然后将等值的点，连接成一条线
    * 网格上每个点的值都有了后，等值线 就是在这些点之间的范围，所以
    * 点越多，等值线越平滑

```python
# 将x,y划分成网格，所以这变必须是单调递增的
#   比如 x=[1,2,3] y=[1,2]，则划分成的网格，一共有6个点，分别为(1,1),(1,2),(2,1),(2,2),(3,1),(3,2)
x=np.linspace(-5,5,100)
y=np.linspace(-5,5,100)
X,Y=np.meshgrid(x,y)

# 计算每个网格点的值，上面划分的网格有 100*100=10000个点
# Z必须是形状为(len(y), len(x))的二维数组
Z = np.sqrt(X**2+Y**2)

# 画图，即将值相等的连接起来，则就是一个等高线
# 当网格点越多，画出的线越平滑
# levels表示等高线的密度
#   levels = 10，表示画10条
#   levels = [1，2]，表示画出值为1和2的等高线
plt.contour(X,Y,Z)

#或者（会自动将x,y转换成网格线）
plt.contour(x,y,Z)
```

##### (12) 3D图
```python
from mpl_toolkits.mplot3d.axes3d import Axes3D
```

* 3D折线图
```python
x = np.linspace(0,100,400)
y = np.sin(x)
z = np.cos(x)

fig = plt.figure()
axes = Axes3D(fig,auto_add_to_figure=False)
fig.add_axes(axes)
axes.plot(x,y,z)
```

* 3D散点图
```python
data = np.random.randint(0,100,size=(100,3))
fig = plt.figure()
axes = Axes3D(fig,auto_add_to_figure=False)
fig.add_axes(axes)
axes.scatter(data[:,0],data[:,1],data[:,2])
```

* 3D柱形图
```python
fig = plt.figure()
axes = Axes3D(fig,auto_add_to_figure=False)
fig.add_axes(axes)

x=np.arange(1,5)

for m in x:
    axes.bar(
        np.arange(4),
        np.random.randint(10,100,size=4),
        zs=m, #在x轴的第几个
        zdir='x' #在哪个方向上排列
    )
```

***

### 图片处理

#### 1.基本处理

```python
img=plt.imread('a.png')
plt.imshow(img)
plt.imsave(<path>, img)
```