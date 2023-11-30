# matplotlib

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [matplotlib](#matplotlib)
    - [概述](#概述)
      - [1.matplotlib](#1matplotlib)
    - [使用](#使用)
      - [1.使用pyplot](#1使用pyplot)

<!-- /code_chunk_output -->

### 概述

#### 1.matplotlib
用于画图

***

### 使用

#### 1.使用pyplot
```python
from matplotlib import pyplot

#设置x、y轴的范围
pyplot.axis([0, 1500, 0, 10000])
pyplot.plot(<x_data_list>, <y_data_list>, color = "r")  #r表示red

#标记x轴（如果不标记，则会根据数据来标记x轴）
pyplot.xticks([0, 200, 400, 600, 800, 1000, 1200, 1400])

#会有网格线
pyplot.grid(True)
pyplot.show()
```
