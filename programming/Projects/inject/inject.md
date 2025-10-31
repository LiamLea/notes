# Inject


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Inject](#inject)
    - [Overview](#overview)
      - [1.What](#1what)
      - [2.concepts](#2concepts)
      - [3.Injector struct](#3injector-struct)

<!-- /code_chunk_output -->


[xref](https://github.com/theplant/inject)

### Overview

#### 1.What

* [dependency injections](https://medium.com/avenue-tech/dependency-injection-in-go-35293ef7b6)

* receive func to generate all needed dependencies such as DB,logger,etc.

#### 2.concepts

#### 3.Injector struct

```go
type Injector struct {
	mu sync.RWMutex

	values    map[reflect.Type]reflect.Value
	providers map[reflect.Type]*provider
	parent    *Injector

	maxProviderSeq uint64
	sfg            singleflight.Group
}
```

* values 
    * is used to store dependencies 
    * everything is a Singleton and it'll create your dependencies just once

* providers
    * is used to store funcs which are used to provide dependencies