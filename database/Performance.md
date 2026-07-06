# Performance

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Performance](#performance)
    - [Overview](#overview)
      - [1.Improve Cache Hit](#1improve-cache-hit)
        - [(1) uuid](#1-uuid)
        - [(2) ORDER BY primary_key](#2-order-by-primary_key)
        - [(3) partition](#3-partition)
      - [2.index](#2index)
        - [(1) index size](#1-index-size)

<!-- /code_chunk_output -->


### Overview

#### 1.Improve Cache Hit

##### (1) uuid

| | v4 | v7 |
|---|---|---|
| Generation | Fully random | Timestamp prefix + random |
| B-tree insert | Scatters randomly | Always appends to right end |
| IO pattern | Random | Sequential |
| Cache hit rate | Low | High |

##### (2) ORDER BY primary_key

Append ORDER BY order_code to the source query so the insert order matches the B-tree index. This keeps the B-tree pages for each 1,000-row batch consecutive, allowing them to be prefetched and reused in the cache

```sql
-- bad: rows arrive in updated_at order, B-tree access is random
INSERT INTO orders SELECT * FROM temp ORDER BY updated_at ON CONFLICT ("order_code") ...

-- good: rows arrive in order_code order, B-tree access is sequential
INSERT INTO orders SELECT * FROM temp ORDER BY order_code ON CONFLICT ("order_code") ...
```

##### (3) partition

Partition the table by time (e.g. monthly). Each partition has its own smaller index, making it more likely to fit in `shared_buffers` → higher cache hit rate → less random IO.

Caveat: PostgreSQL unique indexes must include the partition key, so `ON CONFLICT (order_code)` breaks — needs application-level uniqueness or a schema change.

#### 2.index

Index speeds up reads but adds cost to every write — each INSERT/UPDATE must maintain all indexes on the table.

**Unique indexes are especially expensive**: before writing, Postgres must read first to check for conflicts (random IO). Non-unique indexes can just append.

```
INSERT 一行 orders →
  更新 orders heap（表本身）         ← 1次写
  更新 orders_pkey                   ← 1次随机读 + 写
  更新 idx_orders_updated_at         ← 1次随机读 + 写
  更新 uidx_orders_order_code        ← 1次随机读 + 写（唯一性检查）
  更新 uidx_orders_order_code_store_id ← 1次随机读 + 写（唯一性检查）
  更新 uidx_orders_order_code_user_id  ← 1次随机读 + 写（唯一性检查）
  ...
```

| | Read | Write |
|---|---|---|
| More indexes | Faster (more query paths) | Slower (more IO per write) |
| Fewer indexes | Slower (may full-scan) | Faster |

**Rule of thumb**: remove indexes that aren't being used for queries — they're pure write overhead with no benefit.

##### (1) index size

An index is a separate on-disk data structure (B-tree) that copies the indexed column values and organizes them for fast lookup. Every row in the table has a corresponding entry in every index on that table.

Index size depends on:
- **Number of columns**: a composite index on `(order_code, user_id)` stores two UUIDs per entry vs one for a single-column index → roughly 2× the size
- **Value size**: UUID (36 bytes as text) is much larger than a short enum string
- **B-tree fragmentation**: UUID is random, so each insert lands at a random position in the B-tree, causing frequent page splits — pages end up 50–70% full, wasting space. Sequential values (auto-increment, UUID v7) always append to the rightmost leaf, no splits, higher fill rate

```sql
-- inspect index sizes and usage of orders table
SELECT indexrelname AS index,
       pg_size_pretty(pg_relation_size(indexrelid)) AS size,
       idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
WHERE relid = 'orders'::regclass
ORDER BY pg_relation_size(indexrelid) DESC;
```

Indexes with `idx_scan = 0` are never used for queries — pure write overhead. Drop them.