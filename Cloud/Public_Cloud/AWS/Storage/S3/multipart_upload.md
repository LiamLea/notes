# Multiple Upload

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Multiple Upload](#multiple-upload)
    - [Overview](#overview)
      - [1.The Two Fundamental Data Processing Models](#1the-two-fundamental-data-processing-models)
      - [2.Upload Methods](#2upload-methods)
      - [3.single-part vs multiple-part upload](#3single-part-vs-multiple-part-upload)
      - [4.resumable upload protocols](#4resumable-upload-protocols)

<!-- /code_chunk_output -->


### Overview

#### 1.The Two Fundamental Data Processing Models

At the most fundamental level, every data-handling approach reduces to one of only two:

- **Batch** — wait for the full (finite) dataset, then process it as a whole
- **Stream** — process elements continuously as they arrive, without waiting for the whole to exist

#### 2.Upload Methods

| Method | Max Object Size | Why |
|---|---|---|
| Single PUT (AWS SDKs, REST API, or AWS CLI) | 5 GB | S3 enforces a hard 5 GB cap on a single HTTP PUT request body; no resume — a failure means restarting the entire upload |
| Amazon S3 console | 160 GB | Browser uses multipart under the hood but is constrained by in-memory buffering and tab limits |
| Multipart upload API (AWS SDKs, REST API, or AWS CLI) | 50 TB | Up to 10,000 parts × 5 GB each — the actual S3 object size ceiling |

- **Single PUT:** upload a config file, log archive, or small dataset from a script or CI job
  ```sh
  aws s3api put-object --bucket my-bucket --key reports/report.csv --body report.csv
  ```
- **S3 Console:** drag a 10 GB video file into the S3 console UI — no code needed, good for one-off manual uploads
- **Multipart API:** upload a 2 TB nightly database dump, a VM disk image, or an ML model checkpoint — SDK handles splitting automatically
  ```sh
  # aws s3 cp auto-selects single PUT or multipart based on multipart_threshold (default 8 MB)
  aws s3 cp db-dump.tar.gz s3://my-bucket/backups/db-dump.tar.gz \
    --expected-size 2000000000000
  ```

#### 3.single-part vs multiple-part upload

| | Single-Part (`PutObject`) | Multipart Upload |
|---|---|---|
| **Object size limit** | 5 GB | 5 TB |
| **Recommended for** | < 100 MB | ≥ 100 MB |
| **API calls** | 1 | 3+ (create, upload parts, complete) |
| **Parallelism** | No | Yes — parts upload concurrently |
| **Fault tolerance** | Fail = restart entire upload | Fail = retry only the failed part |
| **Resume** | No | Yes — no expiry on in-progress uploads |
| **Upload while producing** | No — need full object | Yes — start before you know final size |
| **Atomicity** | Fully atomic | Not atomic until `CompleteMultipartUpload` |
| **Complexity** | Simple | More complex — must track ETags, upload ID |

The fundamental difference: single-part has one boundary (the end). Multipart creates boundaries throughout — and boundaries are what make resumability possible.

#### 4.resumable upload protocols
chunking is the prerequisite for resumability
* You can only resume from a boundary. If there are no boundaries, there's nowhere to resume from
* Chunks aren't pre-defined slices of a known file — they're just flush points where you pause, get an ack, and create a resume boundary.
* chunks don't need to be the same size

```
chunk 1 [====] ack
chunk 2 [===============================X  drop at 3.9GB
         ↑ resume from here, not from X
```

