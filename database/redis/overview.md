# overview

[toc]

### 概述

#### 1.redis cluster模式架构

![](./imgs/overview_01.png)

* hash slots(0~16383)
  * 计算方式：根据变量名,利用CRC16算法得到一个数值，然后与16384取余，得到的就是slot的值
