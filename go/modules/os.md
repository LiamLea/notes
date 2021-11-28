# os

[toc]

### Application

####  1.file operation
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

#### 2.flag（command-line flag parsing）
```go
func main() {
	name := flag.String("flag_name", "default_value", "promopt")
	conf := flag.String("config", "/etc/xx.conf", "config file path")
	flag.Parse()
	fmt.Println(*name, *conf)
}
```

```shell
$ test.exe --help

Usage of test.exe:
  -config string
        config file path (default "/etc/xx.conf")
  -flag_name string
        promopt (default "default_value")

```
