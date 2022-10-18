# optimizing

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [optimizing](#optimizing)
    - [performance optimizing](#performance-optimizing)
      - [1.some suggestions](#1some-suggestions)

<!-- /code_chunk_output -->

### performance optimizing

#### 1.some suggestions

* use ssd
* 10Gb network
* less replicas for data
  * 1 replica is roughly 3 times faster than 3 replicas
* use bluestore for osd backend storage
* allocate enough cpu and memory for the servers
