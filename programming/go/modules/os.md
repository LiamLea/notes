# OS


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [OS](#os)
    - [使用](#使用)
      - [1.flag（命令行参数）](#1flag命令行参数)

<!-- /code_chunk_output -->

### 使用

#### 1.flag（命令行参数）
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
