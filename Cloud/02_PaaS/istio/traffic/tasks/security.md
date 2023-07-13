# security

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [security](#security)
    - [概述](#概述)
      - [1.mTLS](#1mtls)
        - [（1）auto mTlS](#1auto-mtls)

<!-- /code_chunk_output -->

### 概述

PeerAuthentication is used to configure what type of mTLS traffic the sidecar will accept.
DestinationRule is used to configure what type of TLS traffic the sidecar will send.

#### 1.mTLS

##### （1）auto mTlS
如果upstream的authentication policy是 STRICT模式 或 PERMISSIVE模式，则使用TLS
如果upstream的authentication policy是plain text模式，则不使用TLS
如果upstream没有sidecar，则不使用TLS
