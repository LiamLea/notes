# Message_Authentication

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Message_Authentication](#message_authentication)
    - [Overview](#overview)
      - [1. HMAC](#1-hmac)
        - [(1) Characteristics](#1-characteristics)
        - [(2) HMAC vs Password Hash Algorithms](#2-hmac-vs-password-hash-algorithms)

<!-- /code_chunk_output -->

### Overview

#### 1. HMAC
Hash-based Message Authentication Code — a hash with a **secret key** mixed in.

```
HMAC(message, key) = SHA256(key + SHA256(key + message))
```

The key acts as a secret parameter. Without it, an attacker cannot recompute any hash, making rainbow tables useless.

* **Signing**: server computes HMAC of a message using the key
* **Verification**: recompute HMAC with the same key and compare

##### (1) Characteristics
* **Not reversible** — even knowing the key, you cannot recover the original input; you can only recompute and compare
* Without the key, rainbow tables are useless — attacker must obtain the key first
* If the key leaks, attacker can brute-force by computing HMAC over known inputs — key must be protected (e.g. stored in KMS, not in code)
* Fast — suitable for high-frequency DB lookups (unlike Argon2 which is intentionally slow)

##### (2) HMAC vs Password Hash Algorithms

| | HMAC | Argon2 / bcrypt |
|---|---|---|
| Speed | Fast | Deliberately slow |
| Use case | PII query matching | Password storage |
| Brute-force resistance | Depends on key secrecy | Strong by design |
| Reversible | No | No |

##### (3) PII Storage Pattern

Only useful when PII is stored **encrypted** (not plaintext):

| Column | Value | Purpose |
|---|---|---|
| `email_encrypted` | `KMS_encrypt(email)` | Read original (display, send email) |
| `email_hash` | `HMAC(email, key)` | Indexed DB lookup |

Encrypted value can't be queried directly — encryption uses a random IV so the same input produces a different output each time. HMAC is deterministic, so it can be indexed.