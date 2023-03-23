# 时间相关模块

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [时间相关模块](#时间相关模块)
    - [概述](#概述)
      - [1.相关概念](#1相关概念)
        - [（1）时间戳](#1时间戳)
        - [（2）UTC/GMT](#2utcgmt)
        - [（3）struct time（9元组）](#3struct-time9元组)
    - [time模块](#time模块)
      - [1.基本函数](#1基本函数)
      - [2.struct_time 与 string 之间相关转换](#2struct_time-与-string-之间相关转换)
        - [（1）struct_time -> string](#1struct_time-string)
        - [（2） string -> struct_time](#2-string-struct_time)
      - [3.`time.sleep(0)`](#3timesleep0)
    - [datetime模块](#datetime模块)
    - [dateutil模块](#dateutil模块)
      - [1.解析时间戳](#1解析时间戳)

<!-- /code_chunk_output -->

### 概述

#### 1.相关概念

##### （1）时间戳
某一时间点到`1970-1-1 00:00:00`之间的秒数

##### （2）UTC/GMT
* UTC：universal time coordinated
* GMT：greenwich mean time

就是0时区的时间

##### （3）struct time（9元组）
返回一个元组，有9个属性

***

### time模块

#### 1.基本函数

* 时间戳（返回类型：float）

```python
time.time()
```

* UTC（返回类型：string）

```python
time.ctime()
```

* 9元组（返回类型：struct_time）

```python
#<secs>不填，默认为当前时间到1970-1-1 00:00:00到某一时间点之间的秒数
#返回结果是struct_time
#tm_year,tm_mon,tm_mday,tm_hout,tm_min,tm_sec,tm_wday,tm_yday

#UTC时间
time.gmtime(<secs>)

#当前所在时区的时间
time.localtime(<secs>)   
```

#### 2.struct_time 与 string 之间相关转换

[表示方式](https://docs.python.org/3/library/time.html)

##### （1）struct_time -> string
```python
#f:format，tuple -> str
#<struct_time>不填，默认是当前时间的struct_time
time.strftime('%Y-%m-%d %H:%M:%S %a', <struct_time>)
```

##### （2） string -> struct_time
```python
#p:parse，str -> tuple
time.strptime('2019-01-01','%Y-%m-%d')
```

#### 3.`time.sleep(0)`
表示放弃当前时间片，强制cpu轮转

***

### datetime模块
```python
t = datetime.datetime.now()    
#t为datetime对象
#属性:year,month,day,hour,minute,second,microsecond

#将 datatime对象 转换成 时间字符串
t.strftime('%Y-%m-%d %H:%M:%S')  

#将 时间字符串 转换成datatime对象
datetime.datetime.strptime('2019-01-01','%Y-%m-%d')      


#100天3小时之前的时间
days = datetime.timedelta(days=100,hours=3)
t = datetime.datetime.now()
t-days
```

```python
from dateutil import tz

ctime = "2020-01-01 08:00:00+0000"
t = datetime.datetime.strptime(ctime, "%Y-%m-%d %H:%M:%S%z")
to_zone = tz.gettz("Asia/Shanghai")
t2 = datetime.datetime.astimezone(t, to_zone)
```

***

### dateutil模块

#### 1.解析时间戳
```python
from dateutil import parser,tz
ctime = "2021-06-30T07:49:05.683743418z"
#返回的是struct time
t = parser.parse(ctime)
print(t.strftime('%Y-%m-%d %H:%M:%S') )

#输出指定时区的结果
#设置时区
to_zone = tz.gettz("Asia/Shanghai")
#获取新的struct time
t2 = t.astimezone(to_zone)
print(t2.strftime('%Y-%m-%d %H:%M:%S') )
```
