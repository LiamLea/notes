# Backup And Restore

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Backup And Restore](#backup-and-restore)
    - [Backup](#backup)
      - [1.Intro](#1intro)
      - [2.Automated Backup](#2automated-backup)
        - [(1) Backup window](#1-backup-window)
        - [(2) Backup retention period](#2-backup-retention-period)
      - [3.Continuous Backup](#3continuous-backup)
        - [(1) PITR (point-in-time recovery)](#1-pitr-point-in-time-recovery)

<!-- /code_chunk_output -->


### Backup

#### 1.Intro
* The first snapshot of a DB instance contains the data for the full database
* Subsequent snapshots of the same database are incremental

#### 2.Automated Backup

##### (1) Backup window
* create a snapshot
* During the backup window, storage I/O might be suspended briefly while the backup process initializes

##### (2) Backup retention period
It defines exactly how many days back in time you can go to recover your data

#### 3.Continuous Backup

##### (1) PITR (point-in-time recovery)

* RDS uploads transaction logs for DB instances to Amazon S3 every five minutes.
    * You can restore to any point in time within your backup retention period (take advantage of snapshots and transaction logs)