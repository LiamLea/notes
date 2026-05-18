# SEO

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [SEO](#seo)
    - [Overview](#overview)
      - [1.Meta tags](#1meta-tags)
      - [2.Open Graph tags](#2open-graph-tags)
      - [3.Redirects](#3redirects)
      - [4.Sitemap / robots.txt](#4sitemap--robotstxt)
      - [5.SPA](#5spa)
      - [6.Check SEO](#6check-seo)

<!-- /code_chunk_output -->


### Overview

#### 1.Meta tags

Hidden HTML elements in `<head>` that tell search engines what a page is about. They don't appear on the page itself but influence how search results are displayed.

Key meta tags:

- **`<title>`** — the page title shown in search results and browser tabs (50–60 chars)
- **`<meta name="description">`** — the snippet shown under the title in search results (120–160 chars)
- **`<meta name="robots">`** — controls indexing behavior (`index`, `noindex`, `follow`, `nofollow`)
- **`<meta name="viewport">`** — mobile rendering (important for Core Web Vitals)
- **`<link rel="canonical">`** — tells Google the preferred URL to avoid duplicate content

Examples:

```html
<title>Buy Running Shoes | AcmeStore</title>

<meta name="description" content="Shop lightweight running shoes with free shipping. 500+ styles for men and women." />

<meta name="robots" content="index, follow" />

<meta name="viewport" content="width=device-width, initial-scale=1" />

<link rel="canonical" href="https://example.com/running-shoes" />
```

[xRef](https://developers.google.com/search/docs/appearance/visual-elements-gallery?_gl=1*hsi866*_up*MQ..*_ga*MTI1MTMwODU2Mi4xNzc4NDkwMzA0*_ga_SM8HXJ53K2*czE3Nzg0OTAzMDQkbzEkZzAkdDE3Nzg0OTAzMDQkajYwJGwwJGgw)

#### 2.Open Graph tags

Hidden HTML in `<head>` that controls how a page appears when shared on social platforms (Facebook, LinkedIn, Slack, iMessage, etc.). Without them, platforms guess — usually poorly.

Core tags:

- **`og:title`** — title shown in the preview card (can differ from `<title>`)
- **`og:description`** — description shown in the preview card
- **`og:image`** — thumbnail image for the card (recommended: 1200×630px)
- **`og:url`** — canonical URL of the page
- **`og:type`** — content type: `website`, `article`, `product`, etc.

Twitter/X uses its own variant (`twitter:card`, `twitter:title`, etc.) but falls back to `og:*` if missing.

Examples:

```html
<meta property="og:title" content="Buy Running Shoes | AcmeStore" />
<meta property="og:description" content="Shop lightweight running shoes with free shipping. 500+ styles for men and women." />
<meta property="og:image" content="https://example.com/images/running-shoes-og.jpg" />
<meta property="og:url" content="https://example.com/running-shoes" />
<meta property="og:type" content="website" />

<!-- Twitter/X card (optional if og:* is set) -->
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:title" content="Buy Running Shoes | AcmeStore" />
<meta name="twitter:image" content="https://example.com/images/running-shoes-og.jpg" />
```

#### 3.Redirects

When a URL changes, tell Google the old URL now lives at the new URL so link equity (ranking power) transfers instead of being lost.

Types:

- **301 Permanent** — use when a page has moved for good (Google transfers ~99% of link equity). Most common for SEO.
- **302 Temporary** — use when a page is temporarily down or being A/B tested (Google keeps the original URL indexed).
- **Meta refresh** — HTML-level redirect (`<meta http-equiv="refresh">`). Avoid — slow and loses link equity.

Common pitfalls:
- **Redirect chains** — A→B→C; Google follows up to 5 hops but loses equity at each step. Flatten to A→C.
- **Redirect loops** — A→B→A; causes crawl errors.
- **Forgetting trailing slash consistency** — `/shoes` vs `/shoes/` should redirect to one canonical form.

  Pick one convention (usually no trailing slash) and enforce it everywhere:

  ```nginx
  # Nginx — strip trailing slash (301)
  rewrite ^(.+)/$ $1 permanent;
  ```

  ```js
  // Next.js next.config.js — strip trailing slash
  module.exports = {
    trailingSlash: false, // redirects /shoes/ → /shoes
  }
  // or trailingSlash: true to enforce /shoes/ everywhere
  ```

  ```js
  // Express middleware — strip trailing slash
  app.use((req, res, next) => {
    if (req.path.endsWith('/') && req.path.length > 1) {
      return res.redirect(301, req.path.slice(0, -1) + (req.url.slice(req.path.length) || ''))
    }
    next()
  })
  ```

  Also set `<link rel="canonical">` to the preferred form as a safety net for pages Google reaches without following the redirect.

#### 4.Sitemap / robots.txt

Two complementary files that guide how Google discovers and crawls your site.

**Sitemap (`sitemap.xml`)** — lists all URLs you want indexed, with optional metadata (last modified, priority). Submit it in Google Search Console. Without it, Google can only discover pages by following links — pages with few inbound links may never get crawled.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://example.com/running-shoes</loc>
    <lastmod>2024-11-01</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>https://example.com/about</loc>
    <priority>0.5</priority>
  </url>
</urlset>
```

For large sites, use a **sitemap index** that references multiple sitemap files:

```xml
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <sitemap>
    <loc>https://example.com/sitemap-products.xml</loc>
  </sitemap>
  <sitemap>
    <loc>https://example.com/sitemap-blog.xml</loc>
  </sitemap>
</sitemapindex>
```

---

**`robots.txt`** — tells crawlers which paths to skip. Lives at the root: `https://example.com/robots.txt`.

```
User-agent: *
Disallow: /admin/
Disallow: /checkout/
Disallow: /search?

# Allow Googlebot everywhere else
User-agent: Googlebot
Allow: /

Sitemap: https://example.com/sitemap.xml
```

Key rules:
- `Disallow` blocks crawling but **not indexing** — if another site links to a disallowed page, Google may still index it. Use `noindex` meta tag to prevent indexing.
- Blocking CSS/JS with `robots.txt` can hurt rendering and rankings — Google needs them to understand the page.
- `Sitemap:` directive at the bottom is the canonical way to tell crawlers where your sitemap is.

#### 5.SPA

The SPA paradox is a classic: you want a fluid, app-like experience, but search engines historically prefer a traditional "multi-page" structure where every URL corresponds to a unique file.

[workaround](https://developers.google.com/search/docs/crawling-indexing/javascript/dynamic-rendering)

#### 6.Check SEO

- [Google Search Console](https://search.google.com/search-console/welcome?utm_source=about-page)
    - how Google sees your site after it’s live
- [Lighthouse](https://github.com/GoogleChrome/lighthouse/tree/7d8dcf5004950cad3faa20664e4a7cf2817bd653)
    - Lighthouse is integrated directly into the Chrome DevTools, which tests your site while you’re building it