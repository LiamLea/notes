# prottp


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [prottp](#prottp)
    - [Overview](#overview)
      - [1.what](#1what)

<!-- /code_chunk_output -->


[source code](https://github.com/theplant/prottp)

### Overview

#### 1.what
* serve Protocol Buffers over HTTP taking advantage of `grpc.ServiceDesc`

```go
func Handle(mux *http.ServeMux, service Service, mws ...server.Middleware) {
	HandleWithInterceptor(mux, service, nil, mws...)
}
```
```go
func HandleWithInterceptor(mux *http.ServeMux, service Service, interceptor grpc.UnaryServerInterceptor, mws ...server.Middleware) {
	sn := service.Description().ServiceName
	fmt.Println("/" + sn)
	hd := WrapWithInterceptor(service, interceptor)
	if len(mws) > 0 {
		hd = server.Compose(mws...)(hd)
	}
	mux.Handle("/"+sn+"/", http.StripPrefix("/"+sn, hd))
}
```
```go
func WrapWithInterceptor(service Service, interceptor grpc.UnaryServerInterceptor) http.Handler {
	mux := http.NewServeMux()

	d := service.Description()

	for _, desc := range d.Methods {
		fmt.Println("/" + d.ServiceName + "/" + desc.MethodName)
		mux.Handle("/"+desc.MethodName, wrapMethod(service, desc, interceptor))
	}

	return mux
}
```
