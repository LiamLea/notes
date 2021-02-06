# editor

[toc]

### sed

#### 1.特点
* 逐行处理
* 不能用双引号,因为$在双引号中表示变量,在单引号中没有特殊含义

#### 2.命令
```shell
sed [<OPTIONS>] '<EXPRESSION>' <FILE>
```

##### （1）选项
```shell
-n  #slient,开启安静模式后就关闭默认输出,默认输出处理后文件的每一行(而不是原始文件)
-e  #expression(-e '命令1',-e '命令2').可以直接使用;号执行多条指令
-r  #regexp-extend,支持扩展正则
-i  #in-place,就地,直接修改原文件
```

##### （2）表达式
表达式由 行控制 和 命令 组成
表达式可以用 ;号 隔开,输入多条,后面的命令是以前一条命令的结果作为输入
表达式可以用\n进行换行,实现多行的插入或替换

##### （3）行控制
```shell
1,7            #1到7行
2,+3           #第2行,即后面的3行
1~3            #第1行并且步长为3
/正则表达式/    #替代行号,所以可以写成
/正则表示式/,7  #表示从匹配的行到第7行
```

##### （4）命令
可以利用`{}`大括号对同一行控制执行多条命令,如`sed -n '5{p;d}' 1.txt`
```shell
p               #print
d               #delete
a,i             #add,在后面插入,insert在前面插入
c               #replace,对行替换

#注意:当替换字符串,符号有冲突时,可以加转义字符.或者可以将///换成!!!或者其他的形式
s/old/new/      #subtitude,替换所有行第1个old
s/old/new/数字   #替换所有行第几个old,如:sed 's/aa/bb/2' 1.txt
s/old/new/g     #global,全部替换

r 文件名        #读入某个文件,然后根据前面的行控制看插入到哪
w 文件名        #根据前面的行控制将特定的内容写入到该文件
```

##### （5）特殊字符
```shell
特殊字符:
  =      #表示行号,sed -n '=' 1.txt ,显示每行的行号
  $      #用于行控制表示最后一行,^不能用于行控制,只能用于表示行首
```

##### （6）demo
```shell
sed -n 'p' 1.txt        #打印所有行
sed -n '1,3p' 1.txt     #打印1-3行
sed -n '1,3!p' 1.txt    #打印除了1-3行的所有行
sed -n '1p;3p' 1.txt    #打印第1行和第3行
sed -n '1,+3p' 1.txt    #打印第1行以及后3行
sed -n '1~3p' 1.txt     #打印第1并且步长设为3(即每跳过3行打印一次)
sed -n '$=' 1.txt       #显示最后一行行号,即有多少行
1,7s/old/new/n          #替换第1-7行的第n个old,如:sed '3s/aa/bb/2' 1.txt
s/^/#/                  #给每行加上注释
```

#### 3.正则的使用
注意这边正则使用的语法跟常规的有些区别，所以有些正则不生效
建议使用

|匹配内容|正则|
|-|-|
|数字|`[:digit:]`|
|空格|`[:space:]`|
|字母|`[:alpha:]`|

***

### awk

#### 1.利用awk给一组数据加标题
* 利用自带标题
```shell
awk 'NR==1{print};/xx/{print}' xx
```

* 自己设置标题
```shell
  awk 'BEGIN{print "title1 title2"}/xx/{print}' xx
```

#### 2.将命令的输出存入变量
```shell
awk '{"<COMMAND>"|getline <VARIABLE_NAME>;print <VARIABLE_NAME>}' <FILE>

#<COMMAND>可以由位置变量组成，比如：
# ps -o pid ax | awk '{"readlink /proc/"$1"/exe"|getline a;print a}'
# awk '{"readlink /proc/22/exe"|getline a;print a}' <FILE>

```
