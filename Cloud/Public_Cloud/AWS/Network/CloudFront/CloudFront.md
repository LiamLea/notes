# CloudFront

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [CloudFront](#cloudfront)
    - [Overview](#overview)
      - [1.Viewer vs Origin](#1viewer-vs-origin)

<!-- /code_chunk_output -->


### Overview

#### 1.Viewer vs Origin
![](./imgs/cf_01.png)

||Viewer Request|Origin Request|
|-|-|-|
|When it runs|Every time a user (viewer) makes a request to CloudFront.|**Only on a cache miss**. If the file is already in the CloudFront cache, this never runs.|
