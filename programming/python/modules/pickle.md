# pickle模块
**可以将任意数据类型写入到文件,并且可以无损的取出(必须以字节方式读写)
常规的文件操作,只能把字符写入文件,不能写其他数据类型**

* 写入特定类型到文件
```python
  alist=['a','b']
  with open('xx','wb') as fobj:
    pickle.dump(alist,fobj)
```
* 读取文件中的特定类型
```python
  with open('xx','rb') as fobj:
    blist=pickle.load(fobj)
```
