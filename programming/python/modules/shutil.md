# shutil模块   
**实现复制,移动等操作**
```python
copy(src,dst)           #src必须为文件,dst可以为目录

copy2(src,dst)          #相当于:cp -p

copytree(src,dst)       #相当于:cp -r

move(src,dst)

rmtree(src)             #只能删除目录

chown(src,owner='xx',group='xx')
```
