# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.`robots.txt`](#1robotstxt)

<!-- /code_chunk_output -->


### 概述

#### 1.`robots.txt`

* 网站有这个文件，就规定了
    * 哪些agent 能够爬取的内容、速率等
* 如果没有这个文件
    * 表示如果对其网站没有危害即可
```shell
curl <url>/robots.txt
```