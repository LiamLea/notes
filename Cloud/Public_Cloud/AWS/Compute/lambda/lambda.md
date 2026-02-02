# lambda


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [lambda](#lambda)
    - [Handler](#handler)
      - [1.Environments](#1environments)
      - [2.Global state](#2global-state)
      - [3.Context](#3context)
        - [(1) Supported variables, methods, and properties](#1-supported-variables-methods-and-properties)
        - [(2) Accessing invoke context information](#2-accessing-invoke-context-information)
        - [(3) Using the context in AWS SDK client initializations and calls](#3-using-the-context-in-aws-sdk-client-initializations-and-calls)
    - [Apply lambda](#apply-lambda)
      - [1.upload lambda](#1upload-lambda)
        - [(1) package (take go)](#1-package-take-go)
      - [2.integrate with other services](#2integrate-with-other-services)

<!-- /code_chunk_output -->

### Handler

[go handler](https://docs.aws.amazon.com/lambda/latest/dg/golang-handler.html)

#### 1.Environments
[xRef](https://docs.aws.amazon.com/lambda/latest/dg/configuration-envvars.html)

#### 2.Global state
* define these global variables in a `var` block or statement.
* declare an `init()` function that is executed during the initialization phase

#### 3.Context

##### (1) Supported variables, methods, and properties

[xRef](https://docs.aws.amazon.com/lambda/latest/dg/golang-context.html#golang-context-library)

##### (2) Accessing invoke context information

* use the context object to monitor how long your Lambda function takes to complete

```go
package main

import (
        "context"
        "log"
        "time"
        "github.com/aws/aws-lambda-go/lambda"
)

func LongRunningHandler(ctx context.Context) (string, error) {

        deadline, _ := ctx.Deadline()
        deadline = deadline.Add(-100 * time.Millisecond)
        timeoutChannel := time.After(time.Until(deadline))

        for {

                select {

                case <- timeoutChannel:
                        return "Finished before timing out.", nil

                default:
                        log.Print("hello!")
                        time.Sleep(50 * time.Millisecond)
                }
        }
}

func main() {
        lambda.Start(LongRunningHandler)
}
```

##### (3) Using the context in AWS SDK client initializations and calls

```go
// Upload an object to S3
    _, err = s3Client.PutObject(ctx, &s3.PutObjectInput{
        ...
    })
```

***

### Apply lambda

#### 1.upload lambda

##### (1) package (take go)

```shell
GOOS=linux GOARCH=amd64 go build -trimpath -ldflags="-s -w" -o bootstrap main.go
```

```tf
data "archive_file" "my_lambda" {
  type        = "zip"
  source_file = "./data/bootstrap"
  output_path = "my_lambda.zip"
}
```

#### 2.integrate with other services

* [s3](https://docs.aws.amazon.com/lambda/latest/dg/with-s3-example.html)