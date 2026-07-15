# Multiple Upload

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Multiple Upload](#multiple-upload)
    - [Overview](#overview)
      - [1.The Two Fundamental Data Processing Models](#1the-two-fundamental-data-processing-models)
      - [2.Upload Methods](#2upload-methods)
      - [3.single-part vs multiple-part upload](#3single-part-vs-multiple-part-upload)
      - [4.resumable upload protocols](#4resumable-upload-protocols)
      - [5.multipart upload steps](#5multipart-upload-steps)
      - [6.Force quit multipart upload](#6force-quit-multipart-upload)

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

#### 5.multipart upload steps

**Step 1: Initiate — `POST /{key}?uploads`**
```http
POST /backups/db-dump.tar.gz?uploads HTTP/1.1
Host: my-bucket.s3.amazonaws.com
Authorization: AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20260715/ap-northeast-1/s3/aws4_request, SignedHeaders=host;x-amz-checksum-algorithm;x-amz-date, Signature=<sig>
x-amz-date: 20260715T120000Z
x-amz-checksum-algorithm: SHA256
Content-Length: 0
```
```xml
<!-- response -->
<InitiateMultipartUploadResult>
  <Bucket>my-bucket</Bucket>
  <Key>backups/db-dump.tar.gz</Key>
  <UploadId>VXBsb2FkIElE...</UploadId>
</InitiateMultipartUploadResult>
```

**Step 2: Upload parts — `PUT /{key}?partNumber=N&uploadId=...`**
```http
PUT /backups/db-dump.tar.gz?partNumber=1&uploadId=VXBsb2FkIElE... HTTP/1.1
Host: my-bucket.s3.amazonaws.com
Authorization: AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20260715/ap-northeast-1/s3/aws4_request, SignedHeaders=content-length;host;x-amz-checksum-sha256;x-amz-date, Signature=<sig>
x-amz-date: 20260715T120001Z
Content-Length: 5000000000
x-amz-checksum-sha256: dGhlIHNhbXBsZSBjaGVja3N1bSBmb3IgcGFydCAxCg==

<binary chunk data>
```
```http
<!-- response — S3 verified checksum before storing; collect ETag for complete step -->
HTTP/1.1 200 OK
ETag: "d8e8fca2dc0f896fd7cb4cb0031ba249"
x-amz-checksum-sha256: dGhlIHNhbXBsZSBjaGVja3N1bSBmb3IgcGFydCAxCg==
```

**Step 3: Complete — `POST /{key}?uploadId=...` with ordered ETag list**
```http
POST /backups/db-dump.tar.gz?uploadId=VXBsb2FkIElE... HTTP/1.1
Host: my-bucket.s3.amazonaws.com
Authorization: AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20260715/ap-northeast-1/s3/aws4_request, SignedHeaders=content-length;host;x-amz-date, Signature=<sig>
x-amz-date: 20260715T120010Z
Content-Type: application/xml
Content-Length: 272

<?xml version="1.0" encoding="UTF-8"?>
<CompleteMultipartUpload>
  <Part>
    <PartNumber>1</PartNumber>
    <ETag>"d8e8fca2dc0f896fd7cb4cb0031ba249"</ETag>
    <ChecksumSHA256>dGhlIHNhbXBsZSBjaGVja3N1bSBmb3IgcGFydCAxCg==</ChecksumSHA256>
  </Part>
  <Part>
    <PartNumber>2</PartNumber>
    <ETag>"b026324c6904b2a9cb4b88d6d61c81d1"</ETag>
    <ChecksumSHA256>dGhlIHNhbXBsZSBjaGVja3N1bSBmb3IgcGFydCAyCg==</ChecksumSHA256>
  </Part>
</CompleteMultipartUpload>
```
```xml
<!-- response — object is now visible; ETag format is MD5-of-part-MD5s-<partcount> -->
<CompleteMultipartUploadResult>
  <Location>https://my-bucket.s3.amazonaws.com/backups/db-dump.tar.gz</Location>
  <Bucket>my-bucket</Bucket>
  <Key>backups/db-dump.tar.gz</Key>
  <ETag>"d41d8cd98f00b204e9800998ecf8427e-2"</ETag>
  <ChecksumSHA256>wqBTnUPBGMjBPRFGkDpd0mZTDMJmCMsMqJE5QVSM3pA=</ChecksumSHA256>
</CompleteMultipartUploadResult>
```

**Abort — `DELETE /{key}?uploadId=...`**
```http
DELETE /backups/db-dump.tar.gz?uploadId=VXBsb2FkIElE... HTTP/1.1
Host: my-bucket.s3.amazonaws.com
Authorization: ...
x-amz-date: 20260715T120020Z
```
```http
HTTP/1.1 204 No Content
```

#### 6.Force quit multipart upload

Uploaded parts stay in S3 as orphaned bytes — invisible in object listings, but still billed. `a.zip` does not exist until `CompleteMultipartUpload` is called.

Check orphaned parts:
```sh
aws s3api list-multipart-uploads --bucket my-bucket
aws s3api list-parts --bucket my-bucket --key backups/a.zip --upload-id VXBsb2FkIElE...
```

Prevent with a lifecycle rule — S3 auto-deletes incomplete uploads after N days:
```json
{ "Rules": [{ "Status": "Enabled", "Filter": {}, "AbortIncompleteMultipartUpload": { "DaysAfterInitiation": 7 } }] }
```
