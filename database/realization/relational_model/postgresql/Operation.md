# Operation

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Operation](#operation)
    - [Overview](#overview)
      - [1.VACUUM](#1vacuum)
        - [(1) `VACUUM` vs `VACUUM FULL`](#1-vacuum-vs-vacuum-full)
        - [(2) autovacuum](#2-autovacuum)
        - [(3) autovaccuum parameters](#3-autovaccuum-parameters)
      - [2.Regular Vacuum vs Anti-wraparound Vacuum](#2regular-vacuum-vs-anti-wraparound-vacuum)
        - [(1) Wraparound](#1-wraparound)
      - [3.Visibility Map](#3visibility-map)
      - [4.Check Vacuum (manual and auto)](#4check-vacuum-manual-and-auto)

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

#### 2.Regular Vacuum vs Anti-wraparound Vacuum

| | Regular Vacuum | Anti-wraparound Vacuum |
|---|---|---|
| **Trigger** | Dead tuples accumulate past a threshold | Table's XID age approaches wraparound limit |
| **Pages read** | Only pages with dead tuples (uses visibility map) | Every page, no exceptions |
| **Goal** | Reclaim dead tuple space | Freeze old XIDs before wraparound |
| **Freezing** | Freezes rows it happens to visit | Freezes all unfrozen rows it finds |
| **Cost** | Cheap — skips most pages | Expensive — reads entire table |
| **Urgency** | Can be deferred | Cannot be cancelled — PG will block writes if needed |

##### (1) Wraparound
* XID (transaction id) has a 2billion counter
* if XID in current XID - 1billion
    * then the XID is in the pass
* if XID in current XID + 1billion
    * then the XID is in the futute(it is invisiable to users)
* froze XID will always be visible to users because they are considered as past transaction
    * Vacuum will freeze rows which is handled by it
    * Vacuum FREEZE will freeze all old rows

#### 3.Visibility Map

* Every table in PostgreSQL has a visibility map (VM) 
    * a **bitmap** where each bit corresponds to a heap page (8kB block of table data)
* The VM records whether all tuples (rows) on that heap page are visible to all transactions
    * Heap fetches = 0 → the VM let it skip all heap lookups
    * Heap fetches > 0 → VM wasn’t helpful, had to touch the heap

#### 4.Check Vacuum (manual and auto)

* check when stats has been reset
```sql
SELECT
    stats_reset,
    NOW() - stats_reset AS time_since_reset
FROM pg_stat_database
WHERE datname = current_database();
```

* check vacuum stats
```sql
SELECT
    t.schemaname,
    t.relname,
    t.last_vacuum,
    t.last_autovacuum,
    COALESCE(
        (SELECT option_value
         FROM pg_options_to_table(c.reloptions)
         WHERE option_name = 'autovacuum_enabled'),
        'true'
    ) AS autovacuum_enabled,
    t.vacuum_count,
    t.autovacuum_count,
    t.n_tup_ins,
    t.n_tup_upd,
    t.n_tup_del,
    t.n_live_tup,
    t.n_dead_tup,
    ROUND(100.0 * t.n_dead_tup / NULLIF(t.n_live_tup + t.n_dead_tup, 0), 2) AS dead_pct
FROM pg_stat_user_tables t
JOIN pg_class c ON c.relname = t.relname AND c.relnamespace = (
    SELECT oid FROM pg_namespace WHERE nspname = t.schemaname
)
ORDER BY t.last_autovacuum DESC NULLS LAST;
```

* `n_tup_ins`: Number of rows inserted since the last stats reset
* `n_tup_upd`: Number of rows updated since the last stats reset
* `n_tup_del`: Number of rows deleted since the last stats reset
* `n_live_tup`: Estimated number of live (visible) rows currently in the table
* `n_dead_tup`: Estimated number of dead (obsolete) rows currently in the table
* `dead_pct > 20%` → Table needs vacuuming