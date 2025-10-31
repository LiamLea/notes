# Viper


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Viper](#viper)
    - [Basic Usage](#basic-usage)
      - [1.Working with ENV](#1working-with-env)

<!-- /code_chunk_output -->


[xRef](https://pkg.go.dev/github.com/spf13/viper#section-readme)

### Basic Usage

#### 1.Working with ENV

```go
SetEnvPrefix("spf") // will be uppercased automatically
BindEnv("id")

os.Setenv("SPF_ID", "13") // typically done outside of the app

id := Get("id") // 13
```

or 

```go
SetEnvPrefix("spf") // will be uppercased automatically
viper.AutomaticEnv()

os.Setenv("SPF_ID", "13") // typically done outside of the app

id := Get("id") // 13
```