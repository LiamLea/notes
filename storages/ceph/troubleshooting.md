# troubleshooting

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [troubleshooting](#troubleshooting)
    - [常见问题](#常见问题)
      - [1.osd crash（无法启动）](#1osd-crash无法启动)

<!-- /code_chunk_output -->

### 常见问题

#### 1.osd crash（无法启动）
可以在osd up的时候，可以把该osd剔除集群（ceph osd out <osd_id>），等数据同步完，再加入集群
