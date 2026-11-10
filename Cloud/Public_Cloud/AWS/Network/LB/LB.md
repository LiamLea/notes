# LoadBalancer

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [LoadBalancer](#loadbalancer)
    - [Overview](#overview)
      - [1. Why ALB has no static IP but NLB does](#1-why-alb-has-no-static-ip-but-nlb-does)
      - [2.Use NLB to decrypt HTTPs](#2use-nlb-to-decrypt-https)

<!-- /code_chunk_output -->


### Overview
AWS Elastic Load Balancing (ELB) has 3 types (excluding the legacy Classic LB):

| | ALB (Application) | NLB (Network) | GWLB (Gateway) |
|---|---|---|---|
| OSI layer | L7 | L4 | L3 |
| Protocols | HTTP, HTTPS, gRPC, WebSocket | TCP, UDP, TLS | IP (GENEVE, port 6081) |
| Routing | path, host, header, query string, method | port | all traffic, flow hash |
| Targets | instance, IP, Lambda | instance, IP, ALB | instance, IP (appliances) |
| Static IP / Elastic IP | ❌ (DNS name only) | ✅ one per AZ | ❌ |
| Preserves client IP | ❌ (use `X-Forwarded-For`) | ✅ | ✅ |
| TLS termination | ✅ | ✅ | ❌ |
| Security groups | ✅ | ✅ | ❌ |
| Latency / scale | ms, auto-scales | µs, millions of req/s | — |
| Typical use | web apps, microservices, k8s ingress | non-HTTP, gaming, IoT, PrivateLink, fixed IP needed | inline firewalls, IDS/IPS, DPI |

**How to choose:**

- HTTP(S) and need content-based routing → **ALB**
- TCP/UDP, extreme performance, or static IP / PrivateLink → **NLB**
- Insert third-party network appliances transparently → **GWLB**

#### 1. Why ALB has no static IP but NLB does

ALB needs real proxy servers (each with its own, changing IP) to hold your TLS certificate and read HTTP, while NLB only forwards packets, which the AWS network can do behind one fixed IP.

#### 2.Use NLB to decrypt HTTPs


TLS listener (decrypt) + TCP target group (plain HTTP to targets):

```
Browser ──HTTPS:443──► NLB (TLS listener, decrypts) ──HTTP:80──► targets
```

```hcl
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 443
  protocol          = "TLS"                         # decrypt here
  certificate_arn   = aws_acm_certificate.this.arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

resource "aws_lb_target_group" "http" {
  port     = 80
  protocol = "TCP"                                  # not TLS → no re-encryption; NLB has no "HTTP" option
  vpc_id   = var.vpc_id
}
```

* No `X-Forwarded-For` / `X-Forwarded-Proto` (NLB can't add HTTP headers)
* Need client IP → enable Proxy Protocol v2 on the target group **and** on the backend (e.g. nginx `listen 80 proxy_protocol;`)
