
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [概述](#概述)
  - [1.BASE 64编码](#1base-64编码)
  - [2. Hash](#2-hash)
    - [(1) Common Hash Algorithms](#1-common-hash-algorithms)
    - [(2) Characteristics](#2-characteristics)
    - [(3) When to Use Hash](#3-when-to-use-hash)
    - [(4) Limitations of Plain Hash](#4-limitations-of-plain-hash)
  - [3. Hash Collision](#3-hash-collision)

<!-- /code_chunk_output -->

### 概述

#### 1.BASE 64编码
将任意二进制数据进行编码，编码成由65个字符（`0~9 a~z A-Z + / =`）中的某些字符组成 的文本文件
* 会使文件比原来更大

#### 2. Hash

##### (1) Common Hash Algorithms
* MD5 (broken, avoid for security use)
* SHA1 (broken, avoid for security use)
* SHA256 (general purpose, widely used)
* bcrypt (password storage)
* Argon2 (password storage, modern standard)

##### (2) Characteristics
* Produces a **fixed-length** output regardless of input size
* **One-way**: cannot be reversed even if the algorithm is known
* **Deterministic**: same input always produces the same output
* **Many-to-one mapping**: infinite inputs map to a finite output space — information is permanently lost

##### (3) When to Use Hash

| Scenario | Algorithm | Reason |
|---|---|---|
| Password storage | Argon2 / bcrypt | Deliberately slow, resists brute-force |
| PII lookup (email, phone) | HMAC-SHA256 | Fast for DB queries, key prevents rainbow tables |
| Data integrity check | SHA256 | Detect if data was tampered with |
| File deduplication / checksums | SHA256 | Identify identical content |

##### (4) Limitations of Plain Hash
* Can be cracked via rainbow tables (precomputed hash → value lookup)
* Early mitigation: **salt** — append a random value before hashing
  * Downside: salt hardcoded in code; if leaked, passwords become vulnerable
* Better solution: **HMAC**

#### 3. Hash Collision
When two different inputs produce the same hash output. MD5 and SHA1 are vulnerable to this. SHA256 is considered collision-resistant for practical purposes.
