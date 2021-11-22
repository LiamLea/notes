# os

[toc]

### 使用

####  1.文件操作
```go
//打开文件
fobj, err := os.OpenFile("./test.txt", os.O_RDWR|os.O_CREATE, 0644)
if err != nil {
  return
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

//写文件
fobj.Write([]byte("xxxx"))
```
