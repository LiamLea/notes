# 概述
### 图的种类
* 时序图
* 用例图
* 类图
* 活动图（流程图）
* 组件图
* 状态图
* 对象图
* 部署图
* 定时图
# 活动图
### 1.基本语法
```shell
start       #关键字，开始标志，生成一个开始图形
:xxx;       #冒号开头，分号结尾
:xxx        #可以实现换行
xxx;
            #会按照顺序进行连线
send        #关键字，结束标志
```
#### 2.示例
```plantuml
start
:PXC集群;
:3.1.5.140;
end
```

# 部署图
### 1.基本语法
```
frame test1{
  card in_test1
}

frame test2{
  card in_test2
}


in_test1->test2   #- 一个横杠表示两个组件在同一水平位置
                  #-- 两个横杠，表示test2在下面一个单位
                  #--- 三个横杠，表示test3在下面两个单位
                  #以此类推

A-->B:"加文字"

```
### 2.示例
```plantuml
frame test1{
  card in_test1
}

frame test2{
  card in_test2
}


in_test1->test2:"haha"
```
