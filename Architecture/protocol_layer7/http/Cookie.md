# Cookie

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Cookie](#cookie)
    - [Overview](#overview)
      - [1.Cookie set by server](#1cookie-set-by-server)
      - [2.Cookie Header (handled by browser)](#2cookie-header-handled-by-browser)
        - [(1) Cookie Storage](#1-cookie-storage)
        - [(2) Lifetime Of A Cookie](#2-lifetime-of-a-cookie)
        - [(3) Security](#3-security)
        - [(4) Define where cookies are sent](#4-define-where-cookies-are-sent)
      - [3.Coookie vs Access/Refresh Token](#3coookie-vs-accessrefresh-token)
        - [(1) which one to choose](#1-which-one-to-choose)

<!-- /code_chunk_output -->


### Overview

#### 1.Cookie set by server

Set by server via Set-Cookie response header

```http
HTTP/1.1 200 OK
Set-Cookie: session_id=abc123; Path=/; HttpOnly; Secure; SameSite=Strict; Max-Age=3600
Set-Cookie: user_pref=dark_mode; Path=/; SameSite=Lax; Max-Age=31536000
Set-Cookie: cart_id=xyz789; Path=/shop; SameSite=Lax
```

The browser stores all three and sends them together in a single `Cookie` header on subsequent requests:

```http
GET /dashboard HTTP/1.1
Host: example.com
Cookie: session_id=abc123; user_pref=dark_mode; cart_id=xyz789
```

#### 2.Cookie Header (handled by browser)

##### (1) Cookie Storage
Browsers are generally limited to a maximum number of cookies per domain (varies by browser, generally in the hundreds), and a maximum size per cookie (usually 4KB)

If you want to storage data, you should consider local storage, memory storage or indexedDB instead of cookie

##### (2) Lifetime Of A Cookie
```http
Set-Cookie: id=a3fWa; Expires=Thu, 31 Oct 2021 07:28:00 GMT;
// or
Set-Cookie: id=a3fWa; Max-Age=2592000
```

Session cookies — cookies without a Max-Age or Expires attribute – are deleted when the current session ends

##### (3) Security
* `Secure` — cookie is only sent over HTTPS; never transmitted over plain HTTP, preventing interception by network attackers

* `HttpOnly` — cookie is inaccessible to JavaScript (`document.cookie`), so even if an XSS attack executes arbitrary JS it cannot read or exfiltrate the cookie

* `SameSite` — controls whether the cookie is sent on cross-site requests
  * `Strict` — only sent on same-site requests (e.g. navigating from `example.com` to `example.com`); never on cross-site navigations
  * `Lax` — sent on same-site requests and top-level navigations (clicking a link); blocked on cross-site sub-resources like images/iframes

    | What happens | Cookie sent? |
    |---|---|
    | You click a link → browser goes to `bank.com` | Yes |
    | You type `bank.com` in the address bar | Yes |
    | You're on `evil.com` and it secretly loads `<img src="bank.com/steal">` | No |
    | You're on `evil.com` and it sends a background `fetch` to `bank.com` | No |
  * `None` — sent on all requests including cross-site; requires `Secure` to be set

##### (4) Define where cookies are sent

The `Domain` and `Path` attributes define the scope of a cookie: what URLs the cookies are sent to

* **`Domain`** — which hostnames receive the cookie; if set to `example.com`, subdomains are included
* **`Path`** — which URL paths receive the cookie (default: `/`)

```
Set-Cookie: session=abc; Domain=example.com; Path=/shop

# Sent to:
#   api.example.com/shop/cart  ✓
#   example.com/shop           ✓
#   example.com/account        ✗  (wrong path)
#   other.com/shop             ✗  (wrong domain)
```

#### 3.Coookie vs Access/Refresh Token

| Feature | Cookie Access | Refresh Token |
|---|---|---|
| Origin Layer | Built into HTTP protocol layer | Application layer (OAuth 2.0) |
| Handler | Browser (automatically attaches to matching domain requests) | Code (JavaScript manually attaches via request headers) |
| Storage Location | Browser Cookie Store | LocalStorage, JS Memory, or HttpOnly Cookie |

##### (1) which one to choose

| Scenario | Choose | Why |
|---|---|---|
| Single-domain web app (Next.js, Django, Rails…) | **Cookies** (session or HttpOnly JWT) | Easiest to secure; `SameSite` handles CSRF; no XSS token theft |
| Mobile / desktop app or third-party API | **Tokens** (OAuth 2.0 / JWT) | Native apps don't handle cookie domains; clients expect `Authorization: Bearer` |
| Decoupled SPA + separate API domain | **Hybrid** (access token in memory + refresh token in HttpOnly cookie) | Combines XSS protection with cross-domain flexibility |

