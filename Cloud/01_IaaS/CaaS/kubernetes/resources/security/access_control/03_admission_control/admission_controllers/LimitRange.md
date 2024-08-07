# LimitRange

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [LimitRange](#limitrange)
    - [概述](#概述)
      - [1.LimitRange 资源](#1limitrange-资源)
    - [使用](#使用)
      - [1.LimitRange](#1limitrange)

<!-- /code_chunk_output -->

### 概述

#### 1.LimitRange 资源
如果pod或container没有设置requests和limits，所在命名空间的LimitRange资源会自动设置
* LimitRange的作用范围是其所在namespace

***

### 使用

#### 1.LimitRange
如果pod或container没有设置requests和limits，所在命名空间的LimitRange资源会自动设置
```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: <name>
  namespace: <namespace>
spec:
  limits:
  - default:          #当没有设置limits时，会用这个值设置limits
      <resouce>: <value>
    defaultRequest:   #当没有设置requests时，会用这个值设置requests
      <resource>: <value>
    max:              #当 设置的limits > 这里的值，则创建pod时会报错
      <resource>: <value>
    min:              #当 设置的requests < 这里的值，则创建pod时会报错
      <resource>: <value>
    type: Container      #指定限制哪类资源（Container和pod）
```
