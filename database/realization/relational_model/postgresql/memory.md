# Memory

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Memory](#memory)
    - [Overview](#overview)
      - [1.Two Types of Memory](#1two-types-of-memory)
        - [(1) Shared memory](#1-shared-memory)
        - [(2) Local (per-process) memory](#2-local-per-process-memory)
      - [2. Shared memory (shared_buff) size](#2-shared-memory-shared_buff-size)

<!-- /code_chunk_output -->


### Overview

#### 1.Two Types of Memory

##### (1) Shared memory

Shared memory is allocated once when the server starts and stays at a **fixed size** until shutdown.

* shared_buffers is a **promise (i.e. virtual memory)**, not a reservation excepting using **huge pages**
  * Shared memory gets physical RAM only when it's first touched
  * Reserving the address range gives the buffer pool a fixed shape and a fixed place that every process can share.

##### (2) Local (per-process) memory

Each connection runs as its own backend process, which allocates private memory as queries need it and frees it when they finish.

#### 2. Shared memory (shared_buff) size

| | RDS for PostgreSQL | Aurora PostgreSQL |
|---|---|---|
| Default formula (in 8 KB pages) | `{DBInstanceClassMemory/32768}` | `SUM({DBInstanceClassMemory/12038}, -50003)` |
| Approx. share of memory | ~25% | ~65–70% (minus ~400 MB) |
| Example: db.r6g.xlarge (32 GiB) | ~7–8 GB | ~20–21 GB |