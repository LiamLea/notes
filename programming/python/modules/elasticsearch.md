# elasticsearch

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [elasticsearch](#elasticsearch)
    - [Introduction](#introduction)
      - [1.compatibility](#1compatibility)
      - [2.features](#2features)
    - [Usage](#usage)
      - [1.basic](#1basic)

<!-- /code_chunk_output -->

### Introduction

#### 1.compatibility
* forward compatibility
  * meaning the module supports greater or equal minor versions of es
* backwards compatibility isn't guranteed

#### 2.features
* thread safety

***

### Usage

#### 1.basic

```python
from elasticsearch import Elasticsearch

#create an es instance
es = Elasticsearch(
    ['3.1.4.221:9200'],
    http_auth = ('elastic', 'Cogiot@2021'),
    maxsize = 10  #maximum number of connections
)

#a refresh makes recent operations on indices avaible for search
es.indices.refresh(index = <index>)
#search docs from an index
result = es.search(index = <index>, size = <int>)


#create or update a document in an index
# not spcifying id will add a document
result = es.index(index = <index>, id = <id>, document = <dict>)
```
