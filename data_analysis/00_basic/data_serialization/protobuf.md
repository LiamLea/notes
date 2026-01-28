# Protobuf

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Protobuf](#protobuf)
    - [Overview](#overview)
      - [1.What](#1what)
      - [2.data schema](#2data-schema)
        - [(1) Schema definition: `.proto`](#1-schema-definition-proto)
        - [(2) encode data to binary](#2-encode-data-to-binary)
        - [(3) decode binary with proto file](#3-decode-binary-with-proto-file)
        - [(4) decode binary without proto file](#4-decode-binary-without-proto-file)
      - [3.Generate codes](#3generate-codes)

<!-- /code_chunk_output -->


### Overview

#### 1.What
to serialize structured data

* efficiently
    * Binary format (not text like JSON)
    * Smaller payloads
* reliably
    * Explicit schema
    * compatibility
        * Adding a new field in protobuf is always safe
* It is only used for **internal** communication
    * If you give your API to outside customers, forcing them to use Protobuf can be hard because they might not want to manage your `.proto` files

#### 2.data schema

##### (1) Schema definition: `.proto`

[xRef](https://protobuf.dev/programming-guides/proto3/)

* `person.proto`
```protobuf
// protobuf version
syntax="proto3";

// define a message
//  optional: field is optional
//  repeated: field is a list
//  = <int>: field number
message Person {
  string name = 1;
  optional int32 age = 2;
  repeated string alias = 3;
}
```

##### (2) encode data to binary
*  encoded binary (**wire format**) includes:
    * `field number`
    * `wire type`
    * `value`
* create **data** according to **message** in `person.proto`: `person.txt`
    ```txt
    name: "Leo"
    age: 30
    alias: "Leon"
    alias: "L"
    ```
* encode data
```shell
protoc \
    --proto_path=. --encode=Person person.proto \
    < person.txt > person.bin
```

##### (3) decode binary with proto file
```shell
protoc \
    --proto_path=. --decode=Person person.proto \
    < person.bin
```
```txt
name: "Leo"
age: 30
alias: "Leon"
alias: "L"
```

##### (4) decode binary without proto file
```shell
protoc --decode_raw < person.bin
```
```shell
1: "Leo"
2: 30
3: "Leon"
3: "L"
```

#### 3.Generate codes

* `person.proto`
```protobuf
syntax = "proto3";

// <where generate this code to> ; <package name>
option go_package = "./pb;pb";

message Person {
  string name = 1;
  optional int32 age = 2;
  repeated string alias = 3;
}
```

* generate `.pb.go`
```shell
protoc --proto_path=. --go_out=. person.proto
```