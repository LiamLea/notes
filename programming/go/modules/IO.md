# IO


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [IO](#io)
    - [使用](#使用)
      - [1.文件操作](#1文件操作)
      - [2.bufio（适用场景: 当io次数多，每次数量小时）](#2bufio适用场景-当io次数多每次数量小时)

<!-- /code_chunk_output -->


### 使用

####  1.文件操作

* 读文件
```go
//打开文件
fobj, err := os.OpenFile("test.txt", os.O_RDONLY, 0)
if err != nil {
  panic(err.Error())
}

//关闭文件
defer fobj.Close()

//读文件
temp := make([]byte, 512)
for {
  _, err := fobj.Read(temp)
  if err != nil {
    return
  }
  fmt.Println(string(temp))
}
```

* 写文件
```go
//打开文件
fobj, err := os.OpenFile("./test.txt", os.O_RDWR|os.O_CREATE, 0644)
if err != nil {
  panic(err.Error())
}

//关闭文件
defer fobj.Close()

//写文件
fobj.Write([]byte("xxxx"))
```

#### 2.bufio（适用场景: 当io次数多，每次数量小时）

![](./imgs/io_01.png)

* 读数据
```go
fobj, err := os.OpenFile("iotest/test.txt", os.O_RDONLY, 0)
if err != nil {
  panic(err.Error())
}

//关闭文件
defer fobj.Close()

//默认缓冲区大小: 4096 bytes
b1 := bufio.NewReader(fobj)

//创建切片，用于存储一次读取的数据
//	当要一次读取的数据 > buff的大小时，则buff就没有用
p := make([]byte, 1024)

_, err = b1.Read(p)

if err != nil {
  return
}

fmt.Println(p)
```

* 写数据
```go
fobj, err := os.OpenFile("test.txt", os.O_RDWR|os.O_CREATE, 0644)
if err != nil {
  panic(err.Error())
}

//关闭文件
defer fobj.Close()

//默认缓冲区大小: 4096 bytes
b1 := bufio.NewWriter(fobj)

//创建切片，用于存储一次写入的数据
//	当要一次读取的数据 > buff的大小时，则buff就没有用
p := []byte("nihaohao")

_, err = b1.Write(p)

if err != nil {
  return
}

//刷新缓冲区（即将缓冲区数据写入文件）
b1.Flush()
```
