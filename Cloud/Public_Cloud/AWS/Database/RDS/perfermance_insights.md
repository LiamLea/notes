# Performance insights

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Performance insights](#performance-insights)
    - [Overview](#overview)
      - [1.Average Active Sessions (AAS)](#1average-active-sessions-aas)
        - [(1) What](#1-what)
        - [(2) Active Sessions in **performance insights**:](#2-active-sessions-in-performance-insights)
        - [(3) Analyze](#3-analyze)

<!-- /code_chunk_output -->


### Overview

#### 1.Average Active Sessions (AAS)

##### (1) What
* Total Sessions: 
    * `SELECT count(*) FROM pg_stat_activity;`
* Active Sessions: 
    * `SELECT count(*) FROM pg_stat_activity WHERE state = 'active';`
* Active connections
    * `SELECT count(*) FROM pg_stat_activity WHERE state = 'active' and backend_type = 'client backend';`
##### (2) Active Sessions in **performance insights**:

AAS is a time-based average so it's not integer

Every second, the RDS engine takes a "snapshot" of all currently running threads. It checks the state of each thread assigned to a session.
* **If a thread is on the CPU**: It counts as **1.0** for that second.
* **If a thread is waiting for a disk (I/O)**: It counts as **1.0** for that second (but colored Blue).
* **If a thread is idle**: It counts as **0**.

##### (3) Analyze

**AAS > Max vCPU**: Your database is "bottlenecked." There are more active sessions than there are CPU cores to handle them