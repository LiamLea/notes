# Cache Control

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Cache Control](#cache-control)
    - [Cache-Control header](#cache-control-header)
      - [1.Revalidate response](#1revalidate-response)
      - [2.Response cache directives](#2response-cache-directives)
      - [3.Request cache directives](#3request-cache-directives)

<!-- /code_chunk_output -->


### Cache-Control header

The HTTP Cache-Control header holds directives (instructions) in both **requests and responses** that control caching in browsers and shared caches (e.g., Proxies, CDNs).

```http
Cache-Control: <directive>, <directive>, ...
```

#### 1.Revalidate response
Ask the origin server whether or not the stored response is still fresh. Usually, the revalidation is done through a [conditional request](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Conditional_requests).

e.g.
```http
GET /article/123 HTTP/1.1
Host: example.com
If-None-Match: "abc123"
```
  * If the resource has not changed, the origin server replies:
  ```http
  HTTP/1.1 304 Not Modified
  ```
  * If it has changed, the server sends:
  ```http
  HTTP/1.1 200 OK
  ETag: "def456"
  # with the new content
  ```

#### 2.Response cache directives

|directive|notes|
|-|-|
|max-age|indicates that the response remains fresh until N seconds after the response is generated|
|s-maxage|indicates how long the response remains fresh in a **shared cache**|
|no-cache|indicates that the response can be stored in caches, but the response must be **validated** with the origin server before each reuse (if no change, then use the cache)|
|no-store|indicates that the response can't be stored in caches|
|private|indicates that the response can be stored only in a private cache (e.g., local caches in browsers)|
|public|indicates that the response can be stored in a shared cache </br></br>if the request had an Authorization header, a shared cache must not store the response unless you explicitly allow it (e.g., public or suitable directives)|
|immutable|indicates that the response will not be updated while it's fresh</br></br>A modern best practice for static resources is to include version/hashes in their URLs, while never modifying the resources — but instead, when necessary, updating the resources with newer versions that have new version-numbers/hashes, so that their URLs are different. That's called the cache-busting pattern.|
|stale-while-revalidate||
|stale-if-error|indicates that the cache can reuse a stale response when an upstream server generates an error, or when the error is generated locally|

* stale-while-revalidate
  * e.g. `Cache-Control: max-age=600, stale-while-revalidate=60`
    * Fresh for 600s.
    * From 600–660s: cache may return the stale copy right away and revalidate in parallel.
    * After 660s: it should fetch/validate before serving. 

#### 3.Request cache directives

|directive|notes|
|-|-|
|max-age|refer to response cache directives|
|max-stale|max-stale tells a cache: “I’m okay receiving a response that’s already expired (stale).”</br></br> `max-stale=10` means if the object is within 10 seconds beyound expiry, the cache will return the object instead of getting it from server|
|min-fresh|Only serve me a cached response if it will still be fresh for at least N more seconds|

