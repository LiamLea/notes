# Target Group

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Target Group](#target-group)
    - [Overview](#overview)
      - [1.Target types](#1target-types)
      - [2.Protocols](#2protocols)
      - [3.Health checks](#3health-checks)
      - [4.Common attributes](#4common-attributes)

<!-- /code_chunk_output -->


### Overview

A target group is **a list of backends + how to reach and health-check them**. The LB forwards traffic to a target group, never directly to instances.

```
Client → LB → Listener (port/protocol) → Rule → Target Group → Targets
```

* One target group belongs to one LB type (ALB, NLB or GWLB)
* One target can be in multiple target groups
* The LB only sends traffic to **healthy** targets

#### 1.Target types

| Type | What you register | Notes |
|---|---|---|
| `instance` | EC2 instance ID | traffic goes to the instance's primary private IP |
| `ip` | IP address | containers (ECS awsvpc, EKS pods), peered VPC, on-prem via VPN/DX |
| `lambda` | Lambda function | ALB only, one function per target group |
| `alb` | an ALB | NLB only, for NLB → ALB (static IP + L7 routing) |

Target type can't be changed after creation.

#### 2.Protocols

| LB | Target group protocol |
|---|---|
| ALB | HTTP, HTTPS (+ protocol version HTTP1, HTTP2, gRPC) |
| NLB | TCP, UDP, TCP_UDP, TLS |
| GWLB | GENEVE |

#### 3.Health checks

* Protocol: TCP, HTTP, HTTPS (ALB: HTTP/HTTPS only)
* HTTP checks: `path` (e.g. `/healthz`) + `matcher` (expected status code, e.g. `200`)
* `interval`, `timeout`, `healthy_threshold`, `unhealthy_threshold` decide how fast a target flips state
* If **all** targets are unhealthy, the LB sends traffic to all of them anyway (fail open)

#### 4.Common attributes

| Attribute | Meaning | Applies to |
|---|---|---|
| Deregistration delay | time to finish in-flight requests before removing a target (default 300s) | all |
| Stickiness | keep a client on the same target (ALB: cookie, NLB: source IP) | ALB, NLB |
| Slow start | ramp traffic up gradually to a new target | ALB |
| Load balancing algorithm | round robin (default), least outstanding requests, weighted random | ALB |
| Client IP preservation | target sees the real client IP | NLB |
| Proxy Protocol v2 | prepend client IP info to the connection; backend must support it | NLB |