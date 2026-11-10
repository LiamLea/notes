# Content Security Policy (CSP)

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Content Security Policy (CSP)](#content-security-policy-csp)
    - [Overview](#overview)
      - [1.What is CSP](#1what-is-csp)
      - [2.Common directives](#2common-directives)
      - [3.Source values](#3source-values)
      - [4.Report-only mode](#4report-only-mode)

<!-- /code_chunk_output -->


### Overview

#### 1.What is CSP

* an HTTP response header that tells the browser **which sources are allowed** to load scripts, styles, images, etc.
* anything not allowed is blocked by the browser
* main purpose: reduce the impact of [XSS](../Attacks/XSS.md) and data injection
    * even if an attacker injects `<script>`, the browser won't run it unless the policy allows it

```
Content-Security-Policy: default-src 'self'; img-src *; script-src 'self' https://cdn.example.com
```

#### 2.Common directives

| directive | controls |
|-|-|
| `default-src` | fallback for all `*-src` directives not set |
| `script-src` | where JavaScript is allowed to come from |
| `style-src` | where CSS is allowed to come from |
| `img-src` | where images are allowed to come from |
| `connect-src` | where fetch / XHR / WebSocket are allowed to connect to |
| `font-src` | where fonts are allowed to come from |
| `frame-src` | what this page can embed in `<iframe>` |
| `frame-ancestors` | who can embed this page (anti-clickjacking) |
| `report-uri` / `report-to` | where to send violation reports |

#### 3.Source values

| value | meaning |
|-|-|
| `'self'` | same origin |
| `'none'` | nothing allowed |
| `https://example.com` | a specific origin |
| `*.example.com` | wildcard subdomains |
| `'unsafe-inline'` | allow inline `<script>` / `style=` (weakens CSP) |
| `'unsafe-eval'` | allow `eval()` (weakens CSP) |
| `'nonce-<random>'` | allow inline scripts with a matching `nonce` attribute |

```html
<!-- header: script-src 'nonce-abc123' -->
<script nonce="abc123">console.log("allowed")</script>
```

#### 4.Report-only mode

* test a policy without blocking anything: violations are only reported, not blocked
    * always logged in the browser console
    * if `report-uri` is set, the browser also POSTs a JSON report to that URL (e.g. `/csp-report`)
    * `report-uri` itself never blocks; blocking depends on the header
        * `Content-Security-Policy` → block + report
        * `Content-Security-Policy-Report-Only` → report only
* roll out with report-only first, then switch to enforcing

```
Content-Security-Policy-Report-Only: default-src 'self'; report-uri /csp-report
```

