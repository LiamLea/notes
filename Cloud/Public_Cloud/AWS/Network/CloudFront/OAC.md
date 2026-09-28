# OAC (Origin Access Control)

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [OAC (Origin Access Control)](#oac-origin-access-control)
    - [Overview](#overview)
      - [1.How It Works](#1how-it-works)
      - [2.Configure](#2configure)
        - [(1) origin_access_control_origin_type](#1-origin_access_control_origin_type)
        - [(2) signing_behavior](#2-signing_behavior)

<!-- /code_chunk_output -->


### Overview

#### 1.How It Works

```
[ Client ]
    │ 1. HTTPS GET /image.png
    ▼
[ Amazon CloudFront (Distribution ABC) ]
    │ 2. Check Edge Cache
    │    ├── Cache Hit  ──► Return cached object directly to Client (Done)
    │    └── Cache Miss ──► Continue to Step 3
    │
    │ 3. Obtain Temporary Credentials
    │    └── Short-lived credentials bound to Distribution ABC's identity:
    │        ├── Access Key ID ('ASIA...')
    │        ├── Secret Access Key  (never sent on the wire)
    │        └── Session Token      (sealed blob issued by AWS; carries the
    │                                secret + session metadata + expiry)
    │
    │ 4. Compute SigV4 Signature
    │    ├── Builds canonical request over method, path, and headers —
    │    │   including x-amz-source-arn and x-amz-security-token
    │    ├── Derives K_signing = HMAC chain over Date → Region → Service
    │    └── signature = HMAC-SHA256(K_signing, string-to-sign)
    │
    │ 5. Send HTTPS Request  (HTTPS + SigV4 are mandatory here)
    │    └── GET /image.png
    │        Host: amzn-s3-demo-bucket.s3.us-east-1.amazonaws.com
    │        x-amz-date: 20260916T101500Z
    │        x-amz-content-sha256: e3b0c442...b855
    │        x-amz-security-token: IQoJb3JpZ2luX2Vj...       ◄── sealed envelope
    │        x-amz-source-arn: arn:aws:cloudfront::123456789012:distribution/ABC
    │        x-amz-source-account: 123456789012
    │        Authorization: AWS4-HMAC-SHA256
    │          Credential=ASIA.../20260916/us-east-1/s3/aws4_request,
    │          SignedHeaders=host;x-amz-content-sha256;x-amz-date;
    │                        x-amz-security-token;x-amz-source-arn;
    │                        x-amz-source-account,
    │          Signature=4f2c...
    ▼
[ Amazon S3 ]
    │ 6. Authentication (who is calling?)
    │    ├── Reads Access Key ID ('ASIA...') from the Credential fieldm, it tells S3 the claimed identity
    │    ├── Decrypts x-amz-security-token to recover the temporary secret key
    │    │   and session metadata  (no credential-store lookup — it all
    │    │   arrived with the request)
    │    ├── Recomputes K_signing and the signature over the canonical request
    │    ├── Compares against the Signature header  (match = authentic)
    │    └── Checks the session has not expired
    │
    │ 7. Authorization (is it allowed?) — Evaluate Bucket Policy
    │    ├── Principal Check: Service == 'cloudfront.amazonaws.com'?        (Yes)
    │    ├── Action Check:    's3:GetObject' on 'amzn-s3-demo-bucket/image.png'? (Yes)
    │    └── Condition Check: AWS:SourceArn ==
    │        'arn:aws:cloudfront::123456789012:distribution/ABC'?           (Yes)
    │        └── Value comes from the signed x-amz-source-arn HEADER,
    │            not from the session token. It is inside SignedHeaders,
    │            so it cannot be altered without breaking the signature.
    │
    │ 8. Object Retrieval & Caching
    │    └── S3 returns HTTP 200 OK ──► CloudFront caches at edge ──► Serves to Client
    ▼
[ Client ]
```

#### 2.Configure
```tf
resource "aws_cloudfront_origin_access_control" "oac" {
    name = "s3-oac-control"
    description = "OAC for CloudFront to S3"
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol = "sigv4"

} 
```

##### (1) origin_access_control_origin_type

* s3
* lambda
* mediapackagev2 (For live video packaging and distribution)
* elemental-mediastore (For video asset storage)

##### (2) signing_behavior
| Value | CloudFront Action | Common Scenario |
| :--- | :--- | :--- |
| **always** | Overwrites/adds CloudFront's SigV4 signature on every request. | Standard private S3 bucket access. |
| **no-override** | Adds CloudFront's signature only if the incoming user request lacks an Authorization header. | Dual-access models (allowing fallback authentication). |
| **never** | Strips/omits CloudFront request signing entirely. | Public origins, end-user presigned URL passthrough, or debugging. |

