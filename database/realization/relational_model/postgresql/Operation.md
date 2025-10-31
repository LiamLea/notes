# Operation


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Operation](#operation)
    - [Overview](#overview)
      - [1.VACUUM](#1vacuum)
        - [(1) `VACUUM` vs `VACUUM FULL`](#1-vacuum-vs-vacuum-full)
        - [(2) autovacuum](#2-autovacuum)
        - [(3) autovaccuum parameters](#3-autovaccuum-parameters)
      - [2.Visibility Map](#2visibility-map)

<!-- /code_chunk_output -->


### Overview

#### 1.VACUUM

##### (1) `VACUUM` vs `VACUUM FULL`

* `VACUUM`
    * Scans the table for dead tuples (including old versions) that are no longer needed by any active transaction and the space is marked as reusable
    * Freed space is marked as reusable by `VACUUM`, but disk file size doesn’t shrink unless you run `VACUUM FULL`

* `VACUUM FULL`
    * it rewrites the entire table into a new file, compacting space
    * Old versions are always removed (even if still in the table file previously)

* example command:
```shell
VACUUM ANALYZE <table_name>
```

##### (2) autovacuum

* Runs `VACUUM` to clean up dead tuples.

* Runs `ANALYZE` to refresh table statistics.

##### (3) autovaccuum parameters
* trigger condition 
    * `vacuum threshold = vacuum base threshold + vacuum scale factor * number of tuples`

* delay
```shell
# pause 25 milliseconds every vaccum 600 rows
autovacuum_vacuum_cost_delay = 25
autovacuum_vacuum_cost_limit = 600
```

#### 2.Visibility Map

* Every table in PostgreSQL has a visibility map (VM) 
    * a **bitmap** where each bit corresponds to a heap page (8kB block of table data)
* The VM records whether all tuples (rows) on that heap page are visible to all transactions
    * Heap fetches = 0 → the VM let it skip all heap lookups
    * Heap fetches > 0 → VM wasn’t helpful, had to touch the heap