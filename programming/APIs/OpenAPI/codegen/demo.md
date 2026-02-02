# Demo

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Demo](#demo)
    - [Simple Hello Project](#simple-hello-project)
      - [1.OpenAPI Spec: `openapi/hello-api.yaml`](#1openapi-spec-openapihello-apiyaml)
      - [2.codegen config: `oapi-codegen.yaml`](#2codegen-config-oapi-codegenyaml)
      - [3.`main.go`](#3maingo)
      - [4.generate code](#4generate-code)

<!-- /code_chunk_output -->


### Simple Hello Project

#### 1.OpenAPI Spec: `openapi/hello-api.yaml`

```yaml
openapi: 3.0.0
info:
  title: Hello API
  version: 1.0.0
paths:
  /hello:
    get:
      operationId: getHello
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema:
                type: object
                required: [message]
                properties:
                  message:
                    type: string
```

#### 2.codegen config: `oapi-codegen.yaml`
```yaml
package: main
generate:
  std-http-server: true
  strict-server: true
  models: true
output: hello-api.gen.go
```

#### 3.`main.go`
```go
package main

import (
	"context"
	"log"
	"net/http"
)

//go:generate go run github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen --config=oapi-codegen.yaml openapi/hello-api.yaml

type Server struct{}

// GetHello implements the StrictServerInterface
func (s *Server) GetHello(ctx context.Context, request GetHelloRequestObject) (GetHelloResponseObject, error) {
	// Because 'message' is required in YAML, it's a plain string in Go (no pointers!)
	return GetHello200JSONResponse{
		Message: "Hello, Gopher!",
	}, nil
}

func main() {
	h := &Server{}
	
	// Create the strict handler wrapper
	strictHandler := NewStrictHandler(h, nil)

	// Route it using the standard library mux
	mux := http.NewServeMux()
	HandlerFromMux(strictHandler, mux)

	log.Println("Server running on http://localhost:8080/hello")
	http.ListenAndServe(":8080", mux)
}
```

#### 4.generate code

```shell
go mod init hello-api
go mod tidy

go get github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen

go generate ./...
go mod tidy

go run .
```

```shell
$ curl http://localhost:8080/hello
```