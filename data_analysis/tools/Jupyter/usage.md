# usage


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [usage](#usage)
    - [使用](#使用)
      - [1.安装](#1安装)
      - [2.界面说明](#2界面说明)
      - [3.快捷键](#3快捷键)
        - [(1) 编辑模式](#1-编辑模式)
        - [(2) 命令模式](#2-命令模式)
      - [4.iPython使用](#4ipython使用)
        - [(1) 查看函数帮助](#1-查看函数帮助)
        - [(2) magic commands](#2-magic-commands)

<!-- /code_chunk_output -->


### 使用

使用的解释器: **iPython**

#### 1.安装

[参考](https://jupyter.org/install)

```shell
#最新版本的可以在conda-forge这个channel中找到
conda create -n jupyter notebook
```

#### 2.界面说明

* 文件上面的`Last Checkpoint:`，表示上一次文件保存的时间 
* 每行左边方框: 
    * `[n]` 表示该代码的运行顺序
    * `[*]` 表示代码正在运行
* markdown格式的内容，需要运行一下，才能渲染

#### 3.快捷键

##### (1) 编辑模式

|快捷键|说明|
|-|-|
|tab|代码提示|
|shift + tab|查看函数说明|
|shift + enter|运行本cell代码，并跳到下一个cell|
|ctrl + enter|运行本cell代码，不跳到下一个cell|
|atl+enter|运行本cell代码，在下方插入新的cell，并跳转过去|

##### (2) 命令模式

|快捷键|说明|
|-|-|
|a|上方插入cell|
|b|下面插入cell|
|dd|删除该cell|
|y|将cell转入代码状态|i
|m|将cell转入markdown状态|

#### 4.iPython使用

##### (1) 查看函数帮助
* 简单帮助: `<func>?`
* 源码: `<func>??`

##### (2) magic commands

[参考](https://ipython.readthedocs.io/en/stable/interactive/magics.html#)

* 运行pyhon文件
    * `%run <python_file>`

* 查看函数运行时间
    * `%time <function_call>`
    * `%timeit <function_call>`
        * 会多次运行，取平均值
         * `%timeit -r 3 -n 1000 <function_call>`
            * run 3次，每次1000次循环
* 查看多行代码运行时间
```python
%%time
...
...
```
```python
%%timeit
...
...
```

* 查看所有变量和函数
    * `%who`
    * 查看更详细的信息
        * `%whos`

* 执行shell命令
    * `!<shell_command>`