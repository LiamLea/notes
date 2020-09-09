# context

[toc]

### 概述

上下文本质就是一个 对象，将 **本次请求相关的所有数据** **封装到** **该对象中**，然后将 **该对象** 存储到 **Local**中

#### 1.上下文管理
* flask中的reuqest是线程安全的
* 当有多个请求到来，会有多个线程来处理请求
* 每个线程的都有自己的存储空间用来存储request对象
* 本质跟threading.local一样，只不过flask为了支持协程，自定义了一个Local对象
  * Local对象本质就是一个字典，key为每个线程的id，然后往指定key存取数据，就能实现各线程数据独立

#### 2.重要的三个类

Local
LocalStack（封装了Local）
LocalProxy（封装了LocalStack）

##### 3.有两类上下文
实现方式都是一样的

* 请求上下文：ctx = RequestContext对象
  * 保存每个线程独有的 request 和 session 相关数据

* 应用上下文：app_ctx = AppContext对象
  * 保存每个线程独有的 app 和 g（全局变量）相关数据

#### 4.请求上下文 处理基本流程

##### （1）请求到来
* ctx = 将 request相关所有数据 和 session相关所有数据 封装到RequestContext对象中
* 将ctx（即RequestContext对象）放到Local中

##### （2）执行视图时
* 导入request
* 调用request的属性时，执行的是LocalProxy对象的指定方法
  * `print(request)` --> LocalProxy对象的`__str__`方法
  * `request.method` --> LocalProxy对象的`__getattr__`方法
* 本质是去Local中取出当前线程的ctx（即RequestContext对象），再在ctx中获取request
  * `request.path`  --> `ctx.request.path`
  * `request.method` --> `ctx.request.method`

##### （3）请求结束
* `ctx.pop()`
将当前线程的ctx（即RequestContext对象）从Local中移除

#### 5.flask中的Local对象为什么使用栈保存数据
如果写web程序（web运行环境），栈中永远保存1条数据
如果写脚本获取app信息时，可能存在app上下文嵌套关系
