#tarfile模块
* 压缩
```python
  tar=tarfile.open('/tmp/xx.tar.gz','w:gz')   
  #已gz格式压缩,压缩后的文件名叫xx.tar.gz
  tar.add('/etc/passwd')              #都是压缩的相对路径,即etc/passwd
  tar.add('/home/student`')
  tar.close()
```

* 解压
```python
  tar=tarfile.open('/tmp/xx.tar.gz')
  tar.extractall(path='解压路径')
  tar.close()
```
* 实现增量备份,需要利用os模块的walk()函数
```python
  list(os.walk('/etc'))

#返回值由多个元组组成,每个元组的结构如下:
#
# ('路径字符串',[路径下的目录列表],[路径下的文件列表])
#
#需要拼接后才能得到一个文件的绝对路径

flist=[]
for path,folders,files in list(os.walk('/etc/security')):
  for file in files:
    flist.append(os.path.join(path,file))    
    #如果要计算每个文件的md5值,用字典
```
