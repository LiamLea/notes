# appkit


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [appkit](#appkit)
    - [Overview](#overview)
      - [1.`serviceContext()`](#1servicecontext)
      - [2.`middleware(ctx)`](#2middlewarectx)
    - [Middlewares](#middlewares)
      - [1.default middleware](#1default-middleware)
        - [(1) Recovery](#1-recovery)
        - [(2) LogRequest](#2-logrequest)
        - [(3) others](#3-others)

<!-- /code_chunk_output -->


[source code](https://github.com/theplant/appkit)

### Overview

```go
func ListenAndServe(app func(context.Context, *http.ServeMux) error) {
    ctx, m, closer, err := ContextAndMiddleware()

    // ...
    
}
```
```go
func ContextAndMiddleware() (context.Context, server.Middleware, io.Closer, error) {
    var funcClosers funcCloser

    // initialize some services and store them in the context
    ctx, ctxCloser := serviceContext()

    funcClosers = append(funcClosers, ctxCloser)

    // ForceContext extracts a Logger from a (possibly nil) context, or returns a log.Default()
    logger := log.ForceContext(ctx)

    mw, mwCloser, err := middleware(ctx)
    if err != nil {
        funcClosers.Close()
        err = errors.Wrap(err, "error configuring service middleware")
        logger.WithError(err).Log()
        return nil, nil, nil, err
    }
    funcClosers = append(funcClosers, mwCloser)

    return ctx, mw, funcClosers, nil
}
```

#### 1.`serviceContext()`

* generate the Background context
* install service
    * generate a new value context
        * its **parent context** is the last context
        * the context stores the service (key-value, value stores the service instance)
        * e.g. install logger: `logger, ctx := installLogger(ctx, serviceName)`
        ```go
        type key int

        const loggerKey key = iota

        // Context installs a given Logger in the returned context
        func Context(ctx context.Context, l Logger) context.Context {
            return context.WithValue(ctx, loggerKey, l)
        }
        ```
    * then install other services in the way like logger

#### 2.`middleware(ctx)`

```go
func middleware(ctx context.Context) (server.Middleware, io.Closer, error) {
    logger := log.ForceContext(ctx)

    tC, tracer, err := tracing.Tracer(logger)
    if err != nil {
        logger.Warn().Log(
            "msg", errors.Wrap(err, "error configuring tracer"),
            "err", err,
        )

        // tracing returns a null closer if there's an error
        tC = noopCloser
        tracer = server.IdMiddleware
    }

    return server.Compose(
        withAWSConfig(kitaws.ForceContext(ctx)),
        httpAuthMiddleware(logger),
        corsMiddleware(logger),
        newRelicMiddleware(logger),
        avoidClickjackingMiddleware(logger),
        hstsMiddleware(logger),
        monitoring.WithMonitor(monitoring.ForceContext(ctx)),
        errornotifier.Recover(errornotifier.ForceContext(ctx)),
        tracer,
        server.DefaultMiddleware(logger),
    ), tC, nil
}
```
* a `server.Middleware` is actually a handler
    * a handler is structure 
        * has a property pointing to another handler which implents ServeHTTP interface
        * implents ServeHTTP interface
    ```go
    type Handler interface {
        ServeHTTP(ResponseWriter, *Request)
    }
    ```
* compose
    ```go
    func Compose(middlewares ...Middleware) Middleware {
        return func(h http.Handler) http.Handler {
            for _, m := range middlewares {
                h = m(h)
            }
            return h
        }
    }
    ```

***

### Middlewares

#### 1.default middleware
```go
func DefaultMiddleware(logger log.Logger) func(http.Handler) http.Handler {
    return Compose(
        // Recovery should come before logReq to set the status code to 500
        Recovery,
        LogRequest,
        log.WithLogger(logger),
        trace.WithRequestTrace,
        contexts.WithHTTPStatus,
    )
}
```

##### (1) Recovery
```go
func Recovery(h http.Handler) http.Handler {
    return http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {
        var statusCode int

        defer func() {
            if statusCode != 0 {
                rw.WriteHeader(statusCode)
            }
        }()

        defer RecoverAndSetStatusCode(&statusCode)

        h.ServeHTTP(rw, r)
    })
}

func RecoverAndSetStatusCode(statusCode *int) {
    if err := recover(); err != nil {
        *statusCode = http.StatusInternalServerError
        panic(err)
    }
}
```

##### (2) LogRequest

* get trace header from request
    * extract TraceID (req_id) and ParentSpanID
* start a span
    * create a new value context whose parent is the original context 
        * store span info in the context
* end a span
* log span
* recover from panic which casued by the last middleware 

##### (3) others
* log.WithLogger(logger)
    * create a new value context including the current context and store logger service
* trace.WithRequestTrace
    * create a new value context including the current context and store a new trace id
* contexts.WithHTTPStatus
    * create a new value context including the current context and store status code