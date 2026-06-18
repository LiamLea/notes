# Web Rendering Strategies

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Web Rendering Strategies](#web-rendering-strategies)
    - [Overview](#overview)
      - [1.SSG — Static Site Generation](#1ssg--static-site-generation)
      - [2.SSR — Server-Side Rendering](#2ssr--server-side-rendering)
      - [3.CSR — Client-Side Rendering](#3csr--client-side-rendering)
      - [4.ISR — Incremental Static Regeneration](#4isr--incremental-static-regeneration)
      - [5.Streaming / Island Architecture](#5streaming--island-architecture)
        - [(1) Astro Islands (Server Islands)](#1-astro-islands-server-islands)
        - [(2) SEO trade-off: two modes](#2-seo-trade-off-two-modes)
      - [6.Hybrid Rendering](#6hybrid-rendering)

<!-- /code_chunk_output -->


### Overview

There are 5 main strategies for rendering web pages, often used in combination (hybrid rendering).

#### 1.SSG — Static Site Generation

HTML is generated at build time and served as static files (e.g., from a CDN).

* Pros: extremely fast, cheap to host, highly scalable — no server runtime per request
* Cons: content can go stale between builds; publish pipeline adds latency (3–5 min typical); CMS must track build state; not suitable for user-specific or real-time data
* Examples: Astro, Next.js static export, Jekyll, Hugo
* Rollback pattern: upload each build to a versioned S3 prefix; a CDN edge function reads a KVS key to route to the active version — switching versions takes ~30s with no rebuild
* Preview: run the same templates in SSR mode to render drafts in real time (WYSIWYG without triggering a build)

#### 2.SSR — Server-Side Rendering

HTML is generated on the server at request time — every request triggers a server-side render.

* Pros: always fresh data, good for SEO, fast first paint
* Cons: every request hits the server; requires a running server (Node.js, Go, etc.)
* Examples: Next.js `getServerSideProps`, Rails, Django

Go-based SSR can achieve 10–40x QPS improvement over Node.js (Next.js) SSR due to Go's concurrency model, but adds maintenance burden.

#### 3.CSR — Client-Side Rendering

The server returns a blank HTML shell + JavaScript. The browser runs JS to render the page.

* Pros: rich interactivity, decoupled frontend/backend
* Cons: slow initial load, poor SEO (content not in initial HTML), requires JS enabled
* Examples: classic React SPA, Vue SPA

#### 4.ISR — Incremental Static Regeneration

Like SSG, but pages are re-built in the background on a schedule without a full redeploy.

* Pros: fresh-ish content without full rebuilds; scales like static
* Cons: Next.js-specific concept; stale window between regenerations
* Examples: Next.js ISR (`revalidate`)

#### 5.Streaming / Island Architecture

Server streams HTML progressively; only interactive parts ("islands") load JavaScript. Static shell arrives immediately, islands hydrate independently.

* Pros: best of SSG + CSR — fast, low JS payload, interactive where needed
* Cons: newer pattern, less tooling maturity
* Examples: Astro (islands), React Server Components, Qwik

##### (1) Astro Islands (Server Islands)

A page is split into two parts:

* **Shell** — the structural frame of the page: layout, product description, images, CMS copy. Same for every visitor. Rendered SSR and cached at the CDN edge for a long time (minutes to hours). Only changes when an editor publishes something.
* **Islands** — small dynamic regions embedded in the shell: current stock level, cart badge, personalised recommendations. Each island is a separate request with its own short cache (or no cache). The browser fetches them independently and slots them into the shell.

```
┌──────────────────────────────────────┐
│  Shell (cached at CDN, long TTL)     │
│  ┌─────────────────────────────────┐ │
│  │  Product title, images, copy    │ │
│  └─────────────────────────────────┘ │
│  ┌──────────────┐  ┌──────────────┐  │
│  │  🏝 Island    │  │  🏝 Island   │  │
│  │  Stock level │  │  Cart badge  │  │
│  │  (no cache)  │  │  (no cache)  │  │
│  └──────────────┘  └──────────────┘  │
└──────────────────────────────────────┘
```

In Astro this is the `server:defer` directive — a component is rendered as a placeholder in the shell and its real content is fetched asynchronously by the browser.

##### (2) SEO trade-off: two modes

**Mode 1 — no `server:defer` (synchronous):** islands render in the same SSR pass. Crawler gets complete HTML with price and stock embedded. Perfect SEO, but the shell contains live data so the CDN cannot cache it.

**Mode 2 — `server:defer` (async):** shell is cached at the CDN (long TTL). Crawler only gets the shell + placeholders on first fetch — price and stock are missing from the initial HTML, creating an SEO risk.

Mitigation: keep SEO-critical content (product name, price) in the shell, or include it in `<script type="application/ld+json">` structured data so crawlers always see it regardless of island deferral.

#### 6.Hybrid Rendering

Most modern apps combine strategies:

* Landing / marketing → SSG
* Blog / docs → SSG or ISR
* Product pages (live pricing) → SSR or ISR
* Dashboard / user-specific → CSR or SSR
* Interactive widgets → CSR (islands)
