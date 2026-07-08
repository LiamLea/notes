# Cost Commitments


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Cost Commitments](#cost-commitments)
    - [Overview](#overview)
      - [1.Reserved Instances (RI)](#1reserved-instances-ri)
      - [(1) normalized units](#1-normalized-units)
      - [2.Savings Plans](#2savings-plans)
      - [3.How to choose](#3how-to-choose)

<!-- /code_chunk_output -->



### Overview

AWS offers two main mechanisms to reduce compute costs in exchange for a usage commitment: **Reserved Instances (RI)** and **Savings Plans**. Both require a 1- or 3-year term and can save up to 72% vs. On-Demand pricing.

| | Reserved Instances | Savings Plans |
|---|---|---|
| Commitment unit | Specific instance attributes | Spend per hour ($) |
| Flexibility | Low–High (depends on type) | High |
| Coverage | EC2, RDS, ElastiCache, Redshift, OpenSearch | EC2, Fargate, Lambda |
| Exchange/modify | Convertible RIs only | N/A (commitment auto-applies) |

#### 1.Reserved Instances (RI)

#### (1) normalized units

Normalized units let one RI cover multiple smaller instances of the same family. RDS uses the same factors as EC2:

| Size | Factor |
|---|---|
| micro | 0.5 |
| small | 1 |
| medium | 2 |
| large | 4 |
| xlarge | 8 |
| 2xlarge | 16 |
| 4xlarge | 32 |
| 8xlarge | 64 |
| 16xlarge | 128 |
| 32xlarge | 256 |

A `db.m5.2xlarge` RI (16) can cover 4× `db.m5.large` (4×4=16), or 2× `db.m5.xlarge` (2×8=16).

Applies within the same instance family, engine, and license only. AZ-scoped RIs must match exact size.

#### 2.Savings Plans

Commit to a minimum hourly spend (e.g. $1.00/hr) for 1 or 3 years. AWS auto-applies the discount up to that amount; anything over is On-Demand.

Discount is off On-Demand price — higher discount means lower cost (e.g. 72% off → you pay 28%).

| Type | Covers | Discount | Flexibility |
|---|---|---|---|
| Compute | EC2 (any region/family/size), Fargate, Lambda | Up to 66% | Highest — change family/region/service freely |
| EC2 Instance | EC2 in one instance family + region | Up to 72% | Size/OS/tenancy flexible within that family+region |
| Database | Aurora, RDS, DynamoDB, ElastiCache, DocumentDB, Timestream, Neptune, Keyspaces, DMS, OpenSearch | Up to 35% | Any engine/family/size/AZ/region; also covers serverless |
| SageMaker AI | SageMaker instances | Up to 64% | Any family/size/region/component |

RIs are applied first; Savings Plans cover the remainder.

#### 3.How to choose

**For EC2 → use Savings Plans.** EC2 Instance Savings Plans match the same discount as Standard RIs (up to 72%) but are more flexible — no exchanges to manage.

**For RDS → use Reserved Instances.** RDS RIs give up to 72% off; Database Savings Plans only give up to 35%. Use Database Savings Plans only if you need to freely switch engines or regions and are willing to pay less discount for that flexibility.
