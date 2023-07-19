# overview


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [overview](#overview)
    - [概述](#概述)
      - [1.3种数据模型的NoSQL](#13种数据模型的nosql)
        - [(1) document model](#1-document-model)
        - [(2) key-value model](#2-key-value-model)
        - [(3) graph model](#3-graph-model)

<!-- /code_chunk_output -->

### 概述

#### 1.3种数据模型的NoSQL

##### (1) document model

* 形如
```json
{
  "_id": 1,
  "title": "The Great Gatsby",
  "author": "F. Scott Fitzgerald",
  "genre": "Fiction",
  "year": 1925
}
```

* 常见的数据库有: MongoDB

##### (2) key-value model

* 形如
```swift
Key: "book:1"
Value: "{\"title\":\"The Great Gatsby\", \"author\":\"F. Scott Fitzgerald\", \"genre\":\"Fiction\", \"year\":1925}"
```

* 常见的数据库有: Redis、Cassandra

##### (3) graph model

* 形如
```yaml
User Nodes:
Node 1: { "name": "Alice", "age": 30 }
Node 2: { "name": "Bob", "age": 28 }
Node 3: { "name": "Carol", "age": 32 }

Friendship Edges:
Edge 1: (Node 1) --FRIEND_OF--> (Node 2)
Edge 2: (Node 1) --FRIEND_OF--> (Node 3)
Edge 3: (Node 2) --FRIEND_OF--> (Node 3)
```

* 常见的数据库有: Neo4j