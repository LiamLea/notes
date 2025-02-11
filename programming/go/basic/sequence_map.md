
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [1.数组](#1数组)
  - [（1）基本使用](#1基本使用)
  - [（2）遍历数组](#2遍历数组)
  - [（3）多维数组](#3多维数组)
- [2.切片（动态数组，类似于列表）](#2切片动态数组类似于列表)
  - [（1）特点](#1特点)
  - [（2）基本使用](#2基本使用)
  - [（3）`append`方法](#3append方法)
  - [（4）`copy`方法](#4copy方法)
- [9.map（类似于字典）](#9map类似于字典)
  - [（1）特点](#1特点-1)
  - [（2）基本使用](#2基本使用-1)

<!-- /code_chunk_output -->

#### 1.数组

##### （1）基本使用
```go
var <VARIABLE> [<LENGTH>]<TYPE>

var a1 [3]int   //a1是一个数组，能够存放3个int类型的数据
                //a1的类型是 [3]int，即长度是数组类型的一部分

//默认如果是int类型，则初始值都是0，如果是bool类型，则初始值都是false

a2 := [3]int{1,2,3}

a3 := []byte  //byte类型，能够支持各种格式的数据（比如int、string等）
```

##### （2）遍历数组
```go
//方式一
var a1 [10]int
for i := 0;i < len(a1);i++ {
  ...
}

//方式二
for index, value := range a1 {
  ...
}
```


##### （3）多维数组
```go
a := [3][2]string {
  {"beijing", "shanghai"},
  {"nanjing", "changzhou"},
  {"yangzhou", "nantong"}
}
```

#### 2.切片（动态数组，类似于列表）

##### （1）特点
* 注意：切片是**引用类型**（即函数传参传递的也是引用类型），即**改变其中一个切片的元素，另一个切片的元素也会改变**，因为指向的是同一个地址
* 拥有 相同元素的 可变长度的序列，底层就是数组
* 切片的长度就是元素的个数
* 切片的容量就是底层数组的长度
* 当append时，切片容量不够了，容量会再扩大原来的一倍

##### （2）基本使用
```go
// declare and intilize an empty slice
es := []int{}

//声明并初始化
var <VARIABLE> []<TYPE>
s1 := []int{1,2,3,4,5}

//只声明
s1 := make([]<TYPE>, <LENGTH>)

//由数组生成切片
s1 := a1[1:3]   // [2,3]，长度：2，容量：4
s2 := a1[:3]    // [1,2,3]，长度：4，容量：5
s3 := a1[1:]    // [2,3,4,5] 长度：4，容量：4
s4 := a1[:]     //长度：5，容量：5

s2[0] = 6   //则s1[0]=6
```

##### （3）`append`方法
```go
s1 := []int{1,2,3}
s2 := []int{4,5,6}

s1 = append(s1, 4, 5)
s1 = append(s1, s2...)   //... 表示当切片拆开成一个个元素
```

##### （4）`copy`方法
```go
s1 := []int{1,2,3}
s2 := make([]int, 3, 3)

copy(s1, s2)   //将s2 copy到 s1
```


#### 9.map（类似于字典）

##### （1）特点
注意：map是**引用类型**（即函数传参传递的也是引用类型）

##### （2）基本使用
要初始化或者使用make
```go
// declare and initialize an empty map
em := map[string]string{}

//使用make初始化
m1 := make(map[<key_type>]<value_type>)   //如果容量不够，会自动扩容（最好给出合适的长度：make(map[<key_type>]<value_type>, <length>) ，这样避免扩容，提高效率）

//赋值初始化
m2 := map[string]string {
  "k1": "value1",   //注意这里的逗号
  "k2": "value2",   //注意这里的逗号
}

//遍历map
for k,v := range m1 {
  ...
}

//删除map指定key
delete(m1, "<KEY>")
```
