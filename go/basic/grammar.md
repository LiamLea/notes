# grammar

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [grammar](#grammar)
    - [概述](#概述)
      - [1.命名](#1命名)
      - [2.基本格式](#2基本格式)
      - [3.变量和常量](#3变量和常量)
        - [（1）声明变量：`var`](#1声明变量var)
        - [（2）声明常量：`const` 和 `iota`](#2声明常量const-和-iota)
      - [4.字符串](#4字符串)
        - [（1）概述](#1概述)
        - [（2）相关操作](#2相关操作)
        - [（3）字符类型](#3字符类型)
      - [5.流程控制](#5流程控制)
        - [（1）if](#1if)
        - [（2）循环（只有for循环）](#2循环只有for循环)
        - [（3）switch](#3switch)
      - [6.指针](#6指针)
      - [7.定义一个新的类型：type](#7定义一个新的类型type)
      - [8.new和make](#8new和make)
      - [9.反射:`reflect`](#9反射reflect)

<!-- /code_chunk_output -->

### 概述

#### 1.命名

* 方法如果对外暴露，则首字母大小，否则首字母小写
* 类（即struct）和函数: 驼峰

#### 2.基本格式

* 只有main包，才能build，生成可执行文件
  * 并且该包内，必须有`main()`函数，该函数为整个程序的入口

* 函数外只能写声明语句
  * 具体的语句（包括变量的赋值等）必须写在函数内部
```go
//package <package_name> 很重要，import时就是import的<package_name>
package main

import (
	"fmt"
)

func main ()  {
	fmt.Println("hello go!")
}
```

#### 3.变量和常量

##### （1）声明变量：`var`
* go语言中的变量必须先声明，再使用
* 在函数内声明的变量，如果没有使用，编译时会报错
```go
var <VARIABLE> <TYPE>
//var name string
//var age int
//var isok bool

// 批量声明变量
var (
  <VARIABLE> <TYPE>
  <VARIABLE> <TYPE>
)

//声明变量并且赋值
var <VARIABLE> <TYPE> = <VALUE>
var <VARIABLE> = <VALUE>
<VARIABLE> := <VALUE>       //最常用的方式，不能在函数外使用
```

* 如果想要忽略一个变量（即不使用），需要使用 `_`
```go
func main() {
  x, _ = func()   //func()函数返回两个变量，一个变量赋值给x，另一个变量忽略，如果不忽略的话，就必须在这个函数内使用该变量
  fmt.Println(x)
}
```


##### （2）声明常量：`const` 和 `iota`
常量是只读的
```go
const a int

const n = 11

const (
  n1 = 3.1415
  n2 = 4
  n3    //如果n3没有指定值，则n3 = n2 = 4
)

const (
  n4 = iota   //在第n行，iota = n-1，所以这里n4 = 0
  n5          //n5 = iota = 1
  n3    //如果n3没有指定值，则n3 = n2 = 4
)
```

#### 4.字符串

##### （1）概述
只能用双引号（单引号只能用于字符）
```go
s1 := "hello"
c1 := 'a'
//单引号内的内容原样输出，包括换行等
s2 := `
diyihang
dierhang
`
```

##### （2）相关操作
* 长度：`len(xx)`
* 拼接：`+`
* 分割：`xx.Split()`

##### （3）字符类型
* byte类型
一个ascii码字符
* rune类型
一个utf-8字符，比如："你" 就是一个rune类型的字符


#### 5.流程控制

##### （1）if
```go
if <EXPRESSION> {
  ...
}
else {
  ....
}
```

##### （2）循环（只有for循环）
```go
//初始语句 和 结束语句 都可以省略，但是分号还是要写
for <初始语句>;<条件表达式>;<每次循环的结束语句> {
  ...
}
```

* 无限循环（类似于while）
```go
for {
  ...
}
```

* 遍历可迭代对象：`for range`
```go
s := "adsfdfg"

for i,v := range s {
  ...
}
```

##### （3）switch
```go
switch n {    //根据n的值，执行不同的内容
case xx:
  ...
case xx:
  ...
default:
  ...
}
```

#### 6.指针
* `&`取地址
* `*`根据地址取值
```go
func changeValue(p *int) {
  *p = 10
}

func main () {
  a := 1
  changeValue(&a)
}
```
```go
//下面帮助理解，一般不会这样用
//错误的写法
var p1 *int  //p为指针（内存地址），指向一个int类型数据
*p1 = 100 //这样是有问题的，因为p1创建时未初始化，是一个空指针，当*p1时就会报空指针错误

//正确的写法
var p1 = new(int)   //new会开辟新的内存空间
*p1 = 100
```

#### 7.定义一个新的类型：type
```go
type <new_type_name> <underlying_type>
```

#### 8.new和make
都是用来分配内存的
new会指向已经初始化的内存空间，返回的是指针
make分配内存并初始化，返回的是数据（一般用于slice、map以及channel）

```go
s1 := make([]int, 10)     //等价于s1 := new([10]int)
s2 := new([]int)
fmt.Println(s1)
fmt.Println(s2)
//[0 0 0 0 0 0 0 0 0 0]
//&[]
```

#### 9.反射:`reflect`
```go
reflect.TypeOf(xx)    //获取对象的类型等信息
reflect.ValueOf(xx)   //获取对象的值
```
