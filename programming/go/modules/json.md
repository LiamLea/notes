# json


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [json](#json)
    - [使用](#使用)
      - [1.struct 和 json 互转](#1struct-和-json-互转)
        - [（1）struct -> json](#1struct---json)
        - [（2）json -> struct](#2json---struct)
      - [2.map 和 json 互转](#2map-和-json-互转)

<!-- /code_chunk_output -->


### 使用

* only work with **exported** fields

#### 1.struct 和 json 互转

**注意**：struct中，变量名都必须大写，否则不会转换成json

##### （1）struct -> json
```go
import (
	"encoding/json"
	"fmt"
)

type Student struct {
	Name string
	Age int
	Skill string
}

func main() {
	stu := Student{"tom", 12, "football"}
	data, err := json.Marshal(&stu)
	if err != nil {
		fmt.Printf("序列化错误 err=%v\n", err)
		return
	}
	fmt.Println("序列化后: ", string(data))
}
```

* struct中的key与json中可以的映射关系
```go
type Student struct {
	Name string   `json:"stu_name"`
	Age int       `json:"stu_age"`
	Skill string  // 也可以不指定 tag标签，默认就是 变量名称
}

//其他都一样
```

##### （2）json -> struct
```go
type Student struct {
	Name string
	Age int
	Skill string  // 也可以不指定 tag标签，默认就是 变量名称
}

func main()  {
	str := `{"Name":"tom","Age":12,"Skill":"football"}`
	var stu2 Student
	err := json.Unmarshal([]byte(str), &stu2)
	if err != nil {
		fmt.Printf("反序列化错误 err=%v\n", err)
		return
	}
	fmt.Printf("反序列化后: Student=%v, Name=%v\n", stu2, stu2.Name)
}
```

* struct中的key与json中可以的映射关系
```go
type Student struct {
	Name string   `json:"stu_name"`
	Age int       `json:"stu_age"`
	Skill string  // 也可以不指定 tag标签，默认就是 变量名称
}

func main()  {
	str := `{"stu_name":"tom","stu_age":12,"Skill":"football"}`
	var stu2 Student
	err := json.Unmarshal([]byte(str), &stu2)
	if err != nil {
		fmt.Printf("反序列化错误 err=%v\n", err)
		return
	}
	fmt.Printf("反序列化后: Student=%v, Name=%v\n", stu2, stu2.Name)
}
```

#### 2.map 和 json 互转
```go
func main()  {
	//定义map
	m := make(map[string]interface{})
	m["name"] = "jetty"
	m["age"] = 16

	// map 转 Json字符串
	data, err := json.Marshal(&m)
	if err != nil {
		fmt.Printf("序列化错误 err=%v\n", err)
		return
	}
	fmt.Println("序列化后: ", string(data))
	// 打印: 序列化后:  {"age":16,"name":"jetty"}


	//定义json格式的string（``能够保留双引号）
	str := `{"age":25,"name":"car"}`

	// Json字符串 转 map
	err = json.Unmarshal([]byte(str), &m)
	if err != nil {
		fmt.Printf("反序列化错误 err=%v\n", err)
		return
	}
	fmt.Printf("反序列化后: map=%v, name=%v\n", m, m["name"])
	// 打印: 反序列化后: map=map[age:25 name:car], name=car
}
```
