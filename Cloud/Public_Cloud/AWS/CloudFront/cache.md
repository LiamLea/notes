# Cache


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Cache](#cache)
    - [Cache](#cache-1)
      - [1.How does cache work (take nginx)](#1how-does-cache-work-take-nginx)
        - [(1) Caching based on query string parameters](#1-caching-based-on-query-string-parameters)
        - [(2) Caching based on cookie values](#2-caching-based-on-cookie-values)
        - [(3) Caching based on request headers](#3-caching-based-on-request-headers)
    - [Overview](#overview)
      - [1.Concepts](#1concepts)
        - [(1) orgin and edge](#1-orgin-and-edge)
        - [(2) cache hit ratio](#2-cache-hit-ratio)
      - [2.CloudFront cache params](#2cloudfront-cache-params)
      - [3.Improve cache hit ratio](#3improve-cache-hit-ratio)

<!-- /code_chunk_output -->


### Cache

#### 1.How does cache work (take nginx)

##### (1) Caching based on query string parameters
* nginx config
```nginx
proxy_cache_key "$scheme$host$request_uri";
```
* if a request is:
```http
GET https://example.com/products?page=2&sort=price
```
* the cache key is:
```
httpsexample.com/products?page=2&sort=price
```

##### (2) Caching based on cookie values
* nginx config
```nginc
proxy_cache_key "$scheme$host$request_uri$cookie_user_segment";
```

* if a request is:
```http
GET https://example.com/home
Cookie: user_segment=premium
```

* the cache key is:
```
httpsexample.com/homepremium
```

##### (3) Caching based on request headers
* nginx conig
```nginx
proxy_cache_key "$scheme$host$request_uri$http_accept_language";
```
* if a request is:
```http
Accept-Language: en-US
Accept-Language: fr-FR
```
* the cache key is:
```
httpsexample.com/homeen-US
httpsexample.com/homefr-FR
```

***

### Overview

#### 1.Concepts

##### (1) orgin and edge

* With CloudFront caching, more objects are served from CloudFront **edge** locations, which are closer to your users. This reduces the load on your **origin** server and reduces latency.

##### (2) cache hit ratio

* `requests that are served directly from the CloudFront cache` / `all requests`

#### 2.CloudFront cache params

* Default TTL — used **when the origin doesn’t provide any caching info** (no `Cache-Control`/`Expires`). It’s the fallback lifetime.

* Minimum TTL — the floor. If the origin says “cache for 10 seconds” but your Min TTL is 60s, CloudFront will cache it at least 60s.

* Maximum TTL — the ceiling. If the origin says “cache for 2 days” but your Max TTL is 1 day, CloudFront will cache it no longer than 1 day.

#### 3.Improve cache hit ratio