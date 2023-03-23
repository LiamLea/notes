# os模块
* 相关函数
```python
getcwd()            #相当于pwd
listdir()     
listdir('xx')
mkdir('xx')
makedirs('xx')      #相当于mkdir -p
chdir('xx')         #相当于cd xx
symlink('xx','yy')  #相当于 ln -s xx yy
remove('xx')
rmdir('xx')         #只能删除空目录

path.basename('/tmp/abc.txt')   #返回基础部分:abc.txt(如果是目录就返回目录名)
path.dirname('/tmp/abc.txt')    #返回路径部分:/tmp
path.abspath('.')               #返回绝对路径:/tmp
path.split('/tmp/abc.txt')      #切割:('/tmp','abc.txt')
path.join('/tmp','abc.txt')     #拼接:/tmp/abc.txt

path.isabs('xx')    #是绝对路径吗
path.isfile('xx')   #存在并且是文件吗
path.ismount('xx')  #是挂在点吗
path.isdir('xx')    #存在并且是目录吗
path.islinke('xx')  #存在并且是链接吗
path.exists('xx')   #存在吗

os.getpod()         #获取当前进程的pid
```
