### 概念
#### 1.包
当一个目录下有__init__.py这个文件（可以为空）时，这个目录即为一个包
#### 2.包的特点
* 可以被import（当一个目录不是包时不能被import，执行通过路径import该目录下的指定py文件）
* 当被import时，\_\_init__.py文件里的内容就会被执行
* 所以\_\_init__.py里一般import该目录下的文件或者文件中的方法和类等，这样import这个包后，可以直接使用该包导入的模块、函数等（如：包名.函数名）
>比如有以下目录结构  
```python
demo
  |
  package
    |
    __init__.py
    |
    a.py
    |
    b.py
  |
  main.py
```
>\_\_init__.py  
```python
import package.a
from package.b import funcA
```
>main.py
```python
import package      
#可以直接导入包
#导入之后，可以直接使用该包已经导入的模块、函数等
package.a
package.funcA
```
