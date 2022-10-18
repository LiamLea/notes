# optimization

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [optimization](#optimization)
    - [optimization for workload](#optimization-for-workload)

<!-- /code_chunk_output -->

### optimization for workload

* set namespace limits
  * by advantage of LimitRange and ResourceQuota
* prepare for DNS demand
  * If you expect workloads to massively scale up, your DNS service must be ready to scale up as well
