# time模块

* 时间表示方式:
>时间戳: 1970-1-1 00:00:00到某一时间点之间的秒数
  UTC时间:世界协调时
  9元组:返回一个元组,有9个属性

* 时间戳:time()
* UTC:ctime()
* 9元组:localtime()   
```python
tm_year,tm_mon,tm_mday,tm_hout,tm_min,tm_sec,tm_wday,tm_yday
```
**上面三种表示方法可以想换转换**  
* 按特定格式输出 时间字符串,%a代表星期的缩写
```python
strftime('%Y-%m-%d %H:%M:%S %a')
```
* 将 时间字符串 转换成9元组
```python
strptime('2019-01-01','%Y-%m-%d')
```
# datetime模块
* t=datetime.datetime.now()    
>t为datetime对象,属性:year,month,day,hour,minute,second,microsecond

* t.strftime('%Y-%m-%d %H:%M%S')  
>将 datatime对象 转换成 时间字符串

* datetime.datetime.strptime('2019-01-01','%Y-%m-%d')      
>将 时间字符串 转换成datatime对象

* 100天3小时之前的时间
```python
  days=datetime.timedelta(days=100,hours=3)
  t=datetime.datetime.now()
  t-days
```
