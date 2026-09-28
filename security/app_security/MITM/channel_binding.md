# Channel Binding

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Channel Binding](#channel-binding)
    - [Overview](#overview)
      - [1.How does it work](#1how-does-it-work)

<!-- /code_chunk_output -->


### Overview

#### 1.How does it work

```
[ Client ] ---- TLS Tunnel A ---- [ Proxy / MitM ] ---- TLS Tunnel B ---- [ Server ]
            (Unique ID: 0x123)                      (Unique ID: 0xABC)
```

- Client inspects the properties of TLS Tunnel A (e.g., the server's TLS certificate or handshake hash) to compute CBD = 0x123.

- Client embeds 0x123 inside its encrypted authentication payload sent to the server.

- Attacker relays the authentication payload to the server via TLS Tunnel B.

- Server inspects TLS Tunnel B and calculates its expected data: CBD = 0xABC.

- Server decrypts the payload, checks the client's 0x123 against its own 0xABC, sees a mismatch, and rejects the connection.