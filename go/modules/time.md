# time

[toc]

### 使用

#### 1.基本使用
* sleep
```go
//睡10s
time.Sleep(time.Second * 10)
```

* 时间格式化（与其他语言比较有些特殊）
go语言的诞生时间：`2006-01-02 15:04:05`
  * 2006代表年
  * 01代表月
  * 02代表日
  * 15或者03代表时
  * 04代表分
  * 05代表秒
```go
fmt.Println(time.Now().Format("2006/01/02"))
//2021/11/21

fmt.Println(time.Now().Format("2006-01-02 15:04:05.000000"))
//2021-11-21 16:57:00.168394
```

* 将字符串转换成time对象
```go
timeObj, err := time.Parse("2006-01-02", "2021-11-21")
```

#### 2.定时器
```go
//每10s触发一次
timer := time.Tick(time.Second * 10)
for t := range timer {
  fmt.Println("aaa：",t)
}
```
