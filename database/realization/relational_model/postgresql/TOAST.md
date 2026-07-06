# TOAST

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [TOAST](#toast)
    - [Overview](#overview)
      - [1.What](#1what)
      - [2.Why 2KB threshold](#2why-2kb-threshold)
      - [3.Chunks](#3chunks)

<!-- /code_chunk_output -->


### Overview

#### 1.What
TOAST (The Oversized-Attribute Storage Technique) solves the problem of rows that are too large to fit in a single 8KB page.

When a **field exceeds ~2KB**, PostgreSQL automatically moves it out of the main table into a separate TOAST table, leaving only an 18-byte pointer in the main row:

```
Main table (8KB page):
│ order_code | status | ... | ptr(18B) │  ← large field replaced by pointer

TOAST table (separate storage):
│ full content (e.g. 21KB JSON, chunked into 8KB pages) │
```

This keeps main table rows small, so more rows fit in shared_buffers.

**Trade-off:** reading a full row requires two round trips — one to the main heap, one (or more) to the TOAST table. A 21KB field is split into ~11 chunks, spread across ~3–4 TOAST pages. If only small columns are selected, TOAST data is never fetched.

#### 2.Why 2KB threshold

`8KB page / 4 = 2KB` — the goal is to fit at least 4 rows per page. Beyond 2KB a field starts crowding out other rows, so TOAST moves it out-of-line.

A page can still hold fewer than 4 rows if many small columns add up to >2KB total — TOAST only triggers per field, not per row.

#### 3.Chunks

TOAST pages are also 8KB, so large values are split into fixed ~2KB chunks:

```
21KB value → 11 chunks → stored across ~3–4 TOAST pages
```

Chunks only exist in the TOAST table. The main page stores only the 18-byte pointer.