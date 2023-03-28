# hashlib模块
* 直接计算md5值
```python
  m=hashlib.md5(b'123456')
  m.hexdigest()
```
* 以更新的方式计算md5值   
**当数据量过大时,采用这种方式**
```python
  m=hashlib.md5()
  m.update(b'12')
  m.update(b'34')
  m.update(b'56')
  m.hexdigest()     #与上面的结果一样
```
