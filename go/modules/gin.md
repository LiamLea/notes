# gin

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [gin](#gin)
    - [使用](#使用)
      - [1.基础使用](#1基础使用)
      - [2.设置路由组](#2设置路由组)
      - [3.异步处理](#3异步处理)
      - [4.全局中间件（即拦截器）](#4全局中间件即拦截器)

<!-- /code_chunk_output -->

### 使用

#### 1.基础使用
```go
import (
	"github.com/gin-gonic/gin"
	"net/http"
)

//定义handler函数
func helloWorld(c *gin.Context){
	c.String(http.StatusOK, "hello world")
}
func main()  {

	//获取路由引擎
	r := gin.Default()

	//注册路由，使用GET方法（ANY表示接受所有方法）:
	r.GET("/hello", helloWorld)

	//启动服务
	r.Run("0.0.0.0:8080")
}
```

#### 2.设置路由组
```go
r := gin.Default()
v1 := r.Group("/v1")
v1.GET("/login", login)
v1.GET("/submit", submit)

v2 := r.Group("/v2")
v2.GET("/login2", loginV2)
v2.GET("/submit2", submitV2)
```

#### 3.异步处理
```go
//定义handler函数
func test(c *gin.Context){

  //使用context的副本，如果直接使用context，异步可能出现线程不安全问题
	copyContext := c.copy()

  //异步执行
  go func() {
    time.sleep(1*Sceond)
  }
}

func main()  {

	//获取路由引擎
	r := gin.Default()

	//注册路由，使用GET方法（ANY表示接受所有方法）:
	r.GET("/test", test)

	//启动服务
	r.Run("0.0.0.0:8080")
}
```

#### 4.全局中间件（即拦截器）
```go
import (
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
)

func middleWare() gin.HandlerFunc {
	return func (c *gin.Context) {
		fmt.Println("执行中间件：在所有handler之前执行")

		//Next()之前都是加载中间件，就是程序启动时，前面的代码就会执行
		//执行中间件
		c.Next()
		fmt.Println("执行中间件：在所有handler之后执行")
	}
}

//定义handler函数
func helloWorld(c *gin.Context){
	fmt.Println("helloWord handler")
	c.JSON(http.StatusOK, gin.H{"key1": "value1"})
}

func main()  {

	//获取路由引擎
	r := gin.Default()

	//注册指定的中间件
	r.Use(middleWare())

	//注册路由，使用GET方法（ANY表示接受所有方法）:
	r.GET("/hello", helloWorld)

	//启动服务
	r.Run("0.0.0.0:8080")
}

/*
每请求一次的输出结果:
  执行中间件：在所有handler之前执行
  helloWord handler
  执行中间件：在所有handler之后执行
*/
```
