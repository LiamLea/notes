# output

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [output](#output)
      - [1.elasticsearch](#1elasticsearch)
      - [2.debug](#2debug)

<!-- /code_chunk_output -->

#### 1.elasticsearch
```shell
elasticsearch {
  hosts => "<IP:PORT>"
  index => "<INDEX>"
  pipeline => "<PIPELINE_NAME>"
}
```

#### 2.debug
```shell
stdout{}    #不要用codec=>json，因为可能不立即输出，需要删除相应的topic后才输出
```
