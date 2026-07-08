# Athena

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Athena](#athena)
    - [Overview](#overview)
      - [1.What](#1what)
        - [(1) Why need Athena](#1-why-need-athena)
        - [(2) Relationship with Glue](#2-relationship-with-glue)
      - [2.Create a table from data source](#2create-a-table-from-data-source)
        - [(1) Supported Data Formats](#1-supported-data-formats)
      - [3.Result Output](#3result-output)
      - [4.When should use S3 + Athena](#4when-should-use-s3--athena)

<!-- /code_chunk_output -->


### Overview

#### 1.What

##### (1) Why need Athena

Athena lets you run SQL queries directly on data stored in S3 without loading it into a database. There are no servers to manage and you pay only per query (per TB scanned). It is useful when you have large volumes of log or event data already in S3 and need ad-hoc analysis without standing up a data warehouse.

##### (2) Relationship with Glue

- **Athena** — query engine; executes SQL but does not store schema
- **Glue** — metadata store; holds table definitions (schema, S3 location, file format) in the **AWS Glue Data Catalog**

Athena reads from the Glue catalog at query time. Tables can be created via Athena DDL or discovered automatically by a Glue Crawler. Dropping a table removes only the catalog entry; S3 data is unaffected.

#### 2.Create a table from data source

Table definitions (schema, S3 location, format) are stored in the **AWS Glue Data Catalog**, not in Athena. Athena is just a query engine that reads metadata from Glue at query time.

- Tables can be created via Athena DDL or by Glue Crawlers (auto-detect schema from S3)

##### (1) Supported Data Formats

Athena supports columnar and compressed formats for efficient scanning:

- **Parquet** — columnar storage; only scans the columns needed, dramatically reducing cost and query time
- **ORC** — similar to Parquet, another columnar format
- **JSON** — flexible but slow; scans entire rows
- **CSV / TSV** — simple but no compression benefit on their own
- **Avro** — row-based, good for streaming ingest pipelines
- **gz / bz2 / snappy / zstd** — compression codecs that reduce storage and bytes scanned; Parquet + Snappy or Parquet + gzip is the recommended default

#### 3.Result Output

Athena is serverless and stateless — it has nowhere to hold result rows itself. S3 acts as the output sink so that:

- Results persist beyond the query session and can be downloaded or read by other tools
- Multiple clients or scheduled jobs can retrieve results without re-running the query
- Large result sets (millions of rows) can be written without memory constraints
- Output files can feed downstream pipelines (e.g. Glue, Lambda, QuickSight)

You specify an S3 prefix as the query result location in workgroup settings or per query.

#### 4.When should use S3 + Athena

Data that is large, append-only, and queried infrequently is a good fit. CloudFront access logs are a typical example:

- **CloudFront logs** — each request generates a log line; volume is too high for CloudWatch Logs to be cost-effective. S3 + Athena lets you query months of traffic history with a single SQL statement.
- **ALB / NLB access logs** — same pattern; AWS writes them directly to S3.
- **S3 server access logs** — audit who accessed which objects.
- **VPC Flow Logs** (exported to S3) — network traffic analysis at scale.
- **CloudTrail logs** — API audit trail; Athena has a built-in CloudTrail table template.
- **Application event logs** — anything your services write to S3 via Kinesis Firehose or direct upload.

CloudWatch Logs is better when you need real-time alerting, metric filters, or live tail. Move logs to S3 when the primary use case is historical analysis, cost matters, or the volume exceeds what CloudWatch Insights handles efficiently.