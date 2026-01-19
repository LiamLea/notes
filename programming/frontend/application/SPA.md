# SPA

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [SPA](#spa)
    - [Overview](#overview)
      - [1.what](#1what)
      - [2.how (browser side)](#2how-browser-side)
        - [(1) browser access:](#1-browser-access)
        - [(2) Server responds with `index.html`](#2-server-responds-with-indexhtml)
        - [(3) Browser parses HTML](#3-browser-parses-html)
        - [(4) JavaScript executes (SPA boots)](#4-javascript-executes-spa-boots)
        - [(5) SPA router matches URL](#5-spa-router-matches-url)

<!-- /code_chunk_output -->


### Overview

#### 1.what
single page application

#### 2.how (browser side)

##### (1) browser access:
```shell
GET https://example.com/settings
```

##### (2) Server responds with `index.html`
* Response is 200 OK
* Response body is `index.html`
* URL in address bar stays `/settings`

##### (3) Browser parses HTML

* Parses HTML
* Builds the DOM
* Sees `<script src="/assets/app.abc123.js">`
* Requests that JS file
    ```shell
    GET /assets/app.abc123.js
    ```
    * At this point: `URL = /settings`

##### (4) JavaScript executes (SPA boots)
```js
const path = window.location.pathname;
// "/settings"
```

##### (5) SPA router matches URL
```js
if (path === "/") {
  renderHome();
} else if (path === "/settings") {
  renderSettings();
} else {
  renderNotFound();
}
```