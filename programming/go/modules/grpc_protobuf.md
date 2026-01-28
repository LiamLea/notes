# grpc and protobuf


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [grpc and protobuf](#grpc-and-protobuf)
    - [概述](#概述)
      - [1.protobuf](#1protobuf)
      - [2.gRPC](#2grpc)
      - [3.`grpc.ServiceDesc`](#3grpcservicedesc)
      - [4.Serve gRPC over HTTP](#4serve-grpc-over-http)
    - [protobuf使用](#protobuf使用)
      - [1.下载protobuf编译器和插件](#1下载protobuf编译器和插件)
      - [2.使用规范](#2使用规范)
        - [（1）`.proto`格式](#1proto格式)
      - [3.基础使用](#3基础使用)
        - [（1）定义消息格式`Persion.proto`](#1定义消息格式persionproto)
        - [（2）对`<name>.proto`进行编译，生成相应的go语言代码: `<name>.pb.go`](#2对nameproto进行编译生成相应的go语言代码-namepbgo)
        - [（3）序列化和反序列化](#3序列化和反序列化)
    - [gRPC使用](#grpc使用)
      - [1.下载protobuf编译器和gRPC插件](#1下载protobuf编译器和grpc插件)
      - [2.基本使用](#2基本使用)
        - [(1) 定义消息格式和rpc接口: `user.proto`](#1-定义消息格式和rpc接口-userproto)
        - [（2）对`<name>.proto`进行编译，生成相应的go语言代码: `<name>.pb.go`和`<name>_grpc.pb.go`](#2对nameproto进行编译生成相应的go语言代码-namepbgo和name_grpcpbgo)
        - [（3）server端](#3server端)
        - [（4）client端](#4client端)
      - [3.Tool](#3tool)
        - [(1) list all methods: `grpcurl`](#1-list-all-methods-grpcurl)

<!-- /code_chunk_output -->

### 概述

#### 1.protobuf
是一种 数据 序列化和反序列化 协议

#### 2.gRPC
[参考](../../../Architecture/distributed_system/microservice/rpc.md)

#### 3.`grpc.ServiceDesc`
* It describes a gRPC service and its methods in a server

* structure
	```go
	type ServiceDesc struct {
		ServiceName string          // Fully-qualified name of the service
		HandlerType interface{}     // Interface that the service must implement
		Methods     []MethodDesc    // Non-streaming RPCs
		Streams     []StreamDesc    // Streaming RPCs
		Metadata    interface{}     // Optional metadata, often set to the .proto filename
	}
	```

* It is auto generated in `.pb.go`
* example
	* the `user.UserService` service has four methods (`CreateUser`, `GetUser`, `ListUsers`, `DeleteUser`)
```go
var UserServiceDesc = grpc.ServiceDesc{
	ServiceName: "user.UserService",
	HandlerType: (*UserServiceServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "CreateUser",
			Handler: func(srv interface{}, ctx context.Context, dec func(interface{}) error, _ grpc.UnaryServerInterceptor) (interface{}, error) {
				in := new(CreateUserRequest)
				if err := dec(in); err != nil {
					return nil, err
				}
				return srv.(UserServiceServer).CreateUser(ctx, in)
			},
		},
		{
			MethodName: "GetUser",
			Handler: func(srv interface{}, ctx context.Context, dec func(interface{}) error, _ grpc.UnaryServerInterceptor) (interface{}, error) {
				in := new(GetUserRequest)
				if err := dec(in); err != nil {
					return nil, err
				}
				return srv.(UserServiceServer).GetUser(ctx, in)
			},
		},
		{
			MethodName: "ListUsers",
			Handler: func(srv interface{}, ctx context.Context, dec func(interface{}) error, _ grpc.UnaryServerInterceptor) (interface{}, error) {
				in := new(ListUsersRequest)
				if err := dec(in); err != nil {
					return nil, err
				}
				return srv.(UserServiceServer).ListUsers(ctx, in)
			},
		},
		{
			MethodName: "DeleteUser",
			Handler: func(srv interface{}, ctx context.Context, dec func(interface{}) error, _ grpc.UnaryServerInterceptor) (interface{}, error) {
				in := new(DeleteUserRequest)
				if err := dec(in); err != nil {
					return nil, err
				}
				return srv.(UserServiceServer).DeleteUser(ctx, in)
			},
		},
	},
}
```

#### 4.Serve gRPC over HTTP
* need a convertor, such as gRPC-Gateway

***

### protobuf使用

#### 1.下载protobuf编译器和插件

* [protobuf编译器](https://github.com/protocolbuffers/protobuf)
  * 需要对proto进行编译，编译成指定语言的代码（比如这里就是go语言的代码）

* 下载protobuf插件
  * 用于 根据 `<name>.proto` -生成-> `<name>.pb.go`
    * 生成命令
    ```shell
    protoc --go_out=./ <name>.proto
    ```
```shell
go get google.golang.org/protobuf/cmd/protoc-gen-go
```

#### 2.使用规范

* 需要在文件中定义好 数据格式，文件以`.proto`结尾

##### （1）`.proto`格式
* 每行必须以`;`结尾
* 定义消息结构必须使用`message`关键词
```go
//指定protobuf版本
syntax="proto3";

//指定 包的路径 和 包名（这里包名就是test）
//  会在<go_package>/目录下生成相关的 *.pb.go文件
option go_package = "my.local/test";

//定义消息结构（这里定义了一个名为Persion的结构）
//  optional表示字段可选，不是必须设置值
//  repeated 表示是一个列表
//  = <int> 表示按什么顺序进行序列化和反序列化
message Person {
  string name = 1;
  optional int32 age = 2;
  repeated string alias = 3;
}
```

#### 3.基础使用

##### （1）定义消息格式`Persion.proto`
```go
//指定协议
syntax="proto3";

//指定包名，会在<go_package>/目录下生成相关的 *.pb.go文件
option go_package = "my.local/test";

//定义消息结构（这里定义了一个名为Persion的结构）
//  optional表示字段可选，不是必须设置值
//  repeated 表示是一个列表
message Person {
  string name = 1;
  optional int32 age = 2;
  repeated string alias = 3;
}
```

##### （2）对`<name>.proto`进行编译，生成相应的go语言代码: `<name>.pb.go`
```shell
protoc.exe --go_out=./ persion.proto
```

* 生成`persion.pb.go`文件，用go语言 定义消息结构 和 提供相关函数

##### （3）序列化和反序列化
```go
package main

import (
	"fmt"
	"google.golang.org/protobuf/proto"
	"test/example/my.local/test"
)

func main() {

	//定义一个消息实体
	persion := &test.Person{
		Name: "liyi",
		Age: proto.Int32(20),
		Alias: []string{"xixi", "haha"},
	}

	//序列化 该消息实体
	msgEncoding,err := proto.Marshal(persion)
	if err != nil {
		panic(err.Error())
	}

	fmt.Println(msgEncoding)

	//创建一个空的消息实体
	msgEntity := test.Person{}
	//反序列化，并用空的消息实体进行接收
	err = proto.Unmarshal(msgEncoding, &msgEntity)
	if err != nil {
		panic(err.Error())
	}

	fmt.Println(msgEntity)
	fmt.Println(msgEntity.GetName())
	fmt.Println(msgEntity.GetAge())
	fmt.Println(msgEntity.GetAlias())
}

/*输出结果:
[10 4 108 105 121 105 16 20 26 4 120 105 120 105 26 4 104 97 104 97]
{{{} [] [] 0xc0000e0160} 0 [] liyi 0xc0000aa12c [xixi haha]}
liyi
20
[xixi haha]
*/
```

***

### gRPC使用

#### 1.下载protobuf编译器和gRPC插件
* [protobuf编译器](https://github.com/protocolbuffers/protobuf)
  * 需要对proto进行编译，编译成指定语言的代码（比如这里就是go语言的代码）

* 下载protobuf插件
  * 用于 根据 `<name>.proto` -生成-> `<name>_grpc.pb.go`
    * 生成命令
    ```shell
    protoc.exe --go_out=./ --go-grpc_out=require_unimplemented_servers=false:./  <name>.proto
    ```
```shell
go get google.golang.org/grpc/cmd/protoc-gen-go-grpc
```

#### 2.基本使用

##### (1) 定义消息格式和rpc接口: `user.proto`

```go
syntax="proto3";

option go_package = "../proto";

//定义消息请求格式
message UserRequest {
  string name = 1;
}

//定义消息返回格式
message UserResponse {
  int32 id = 1;
  string name = 2;
  int32 age = 3;
}

//定义接口
service UserService {
  //定义rpc方法
  rpc GetUserInfo(UserRequest) returns (UserResponse) {}
}
```

##### （2）对`<name>.proto`进行编译，生成相应的go语言代码: `<name>.pb.go`和`<name>_grpc.pb.go`
```shell
protoc.exe --go_out=./ --go-grpc_out=require_unimplemented_servers=false:./  user.proto
```

##### （3）server端
```go
package main

import (
	"context"
	"google.golang.org/grpc"
	"net"
	//导入上一步编译好的proto相关代码
	pb "test/gRPC/proto"
)

//定义一个类（然后实现pb.UserService这个接口）
type UserServiceImpl struct {}

//实例化UserInfoService这个类
var u = UserServiceImpl{}

//实现pb.UserInfoService这个接口
func (s *UserServiceImpl) GetUserInfo(ctx context.Context, in *pb.UserRequest) (resp *pb.UserResponse, err error) {
	if in.Name == "liyi" {
		resp = &pb.UserResponse{
			Name: "liyi",
			Id: 1,
			Age: 20,
		}
	}
	return
}

func main() {
	l,err := net.Listen("tcp", ":1234")
	if  err != nil{
		panic(err.Error())
	}
	//创建grpc server
	s := grpc.NewServer()
	//将实现的接口类注册到grpc server中
	pb.RegisterUserServiceServer(s, &u)
	//启动grpc server
	s.Serve(l)
}
```

##### （4）client端
```go
package main

import (
	"context"
	"fmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	//导入上一步编译好的proto相关代码
	pb "test/gRPC/proto"
)

func main() {
	//连接grpc server
	dial, err := grpc.Dial("127.0.0.1:1234",grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil{
		panic(err.Error())
	}

	//创建grpc client
	client := pb.NewUserServiceClient(dial)

	//构造响应接收体
	req := pb.UserRequest{
		Name: "liyi",
	}
	//调用grpc server端的方法
	info, err := client.GetUserInfo(context.Background(), &req)
	fmt.Println(info)
}
```

#### 3.Tool

##### (1) list all methods: `grpcurl`

```shell
# grpc server needs to enable gRPC Server Reflection
grpcurl -plaintext <grpc_server> list
```