[toc]
# time模块
### 概述
#### 1.时间表示方式:
* 时间戳: 1970-1-1 00:00:00到某一时间点之间的秒数
* UTC时间:世界协调时
* 9元组:返回一个元组,有9个属性

### 使用
#### 1.基本函数
* 时间戳
```python
time.time()
```
* UTC
```python
time.ctime()
```
* 9元组:
```python
time.localtime()   

#tm_year,tm_mon,tm_mday,tm_hout,tm_min,tm_sec,tm_wday,tm_yday
```

#### 2.相互转换
* 按特定格式输出 时间字符串,%a代表星期的缩写
```python
#f:format，tuple -> str
strftime('%Y-%m-%d %H:%M:%S %a')
```
* 将 时间字符串 转换成9元组
```python
#p:parse，str -> tuple
strptime('2019-01-01','%Y-%m-%d')
```

#### 3.`time.sleep(0)`
表示放弃当前时间片，强制cpu轮转

***

# datetime模块
### 使用
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
