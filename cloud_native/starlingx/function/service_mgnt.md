# service  management

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [service  management](#service-management)
    - [概述](#概述)
      - [1.service状态切换](#1service状态切换)

<!-- /code_chunk_output -->

### 概述

#### 1.service状态切换
当active controller切换后，active service也会切换到该active controller上，则另一个controller节点上的对应service状态就是standby或者disabled
