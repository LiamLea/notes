# Query Planner

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Query Planner](#query-planner)
    - [Overview](#overview)
      - [1.query methods](#1query-methods)
        - [(1) Seq Scan](#1-seq-scan)
        - [(2) Index Scan](#2-index-scan)
      - [2.query plan analysis](#2query-plan-analysis)
        - [(1) only see plan](#1-only-see-plan)
        - [(2) run and see plan](#2-run-and-see-plan)

<!-- /code_chunk_output -->


### Overview

#### 1.query methods

##### (1) Seq Scan
reads every single row

##### (2) Index Scan
uses a B-Tree (or other index types) to locate the specific rows

#### 2.query plan analysis

##### (1) only see plan
```sql
EXPLAIN <query_sql>;
```

* example
```sql
EXPLAIN SELECT * FROM telemetry_log 
WHERE device_id = 42 
AND created_at > NOW() - INTERVAL '1 hour';
```
```
Index Scan using idx_device_id on telemetry_log  (cost=0.56..12540.30 rows=150 width=28)
  Index Cond: (device_id = 42)
  Filter: (created_at > (now() - '01:00:00'::interval))
```
* Method: Index Scan. The planner saw the index on device_id and decided to use it to narrow down the 50 million rows to just the ones for Device 42.

* Cost Guess (0.56..12540.30): The cost is relatively low because it's not reading the whole table, but it's not "cheap" either because it expects to find a fair amount of data for that device.

* Filter: Notice that created_at is a Filter, not an Index Cond. This means the database finds all rows for Device 42 first, then manually checks the timestamp for each one.

* Rows (rows=150): It estimates that Device 42 had about 150 readings in the last hour.

##### (2) run and see plan
```sql
EXPLAIN ANALYZE <query_sql>;
```

* example
```sql
EXPLAIN ANALYZE SELECT * FROM telemetry_log 
WHERE device_id = 42 
AND created_at > NOW() - INTERVAL '1 hour';
```
```
Index Scan using idx_device_id on telemetry_log  (cost=0.56..12540.30 rows=150 width=28) (actual time=0.842..450.120 rows=85000 loops=1)
  Index Cond: (device_id = 42)
  Filter: (created_at > (now() - '01:00:00'::interval))
  Rows Removed by Filter: 1200000
Planning Time: 0.210 ms
Execution Time: 452.330 ms
```

* Actual Time (450.120 ms): This is quite slow for a single device lookup.

* The "Estimation Nightmare": Look at the rows. The planner expected 150 rows, but it actually found 85,000 rows.

* Rows Removed by Filter (1,200,000): This is the bottleneck. Because we didn't have an index on created_at, the database had to pull 1.2 million rows for Device 42 from the disk just to realize that most of them were older than one hour.

* The Verdict: The "Method" was correct (Index Scan), but the "Index" was incomplete. We need a Composite Index on (device_id, created_at).