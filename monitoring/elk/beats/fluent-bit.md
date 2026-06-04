# fluent-bit


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [fluent-bit](#fluent-bit)
    - [Configuration](#configuration)
      - [1.basic](#1basic)
      - [2.CRI Multiline Parsing](#2cri-multiline-parsing)

<!-- /code_chunk_output -->


### Configuration

#### 1.basic
```toml
[SERVICE]
    Flush                     5
    Grace                     30
    Log_Level                 info
    Daemon                    off

    # include parsers configuration file
    Parsers_File              parsers.conf

    # exposes the some endpoints for monitoring.
    HTTP_Server               ${HTTP_SERVER}
    HTTP_Listen               0.0.0.0
    HTTP_Port                 ${HTTP_PORT}

[INPUT]
    Name <input_plugin>
    Tag  <id>
    Parser <parser_name>

[FILTER]
    Name  <filter_plugin>
    # match tag
    Match <tag>

[OUTPUT]
    Name  <output_plugin>
    # match tag
    Match <tag>
```

* `parsers.conf`
```toml
[PARSER]
    Name                syslog
    Format              regex
    Regex               ^(?<time>[^ ]* {1,2}[^ ]* [^ ]*) (?<host>[^ ]*) (?<ident>[a-zA-Z0-9_\/\.\-]*)(?:\[(?<pid>[0-9]+)\])?(?:[^\:]*\:)? *(?<message>.*)$
    Time_Key            time
    Time_Format         %b %d %H:%M:%S

[PARSER]
    Name                docker
    Format              json
    Time_Key            time
    Time_Format         %Y-%m-%dT%H:%M:%S.%LZ
```

#### 2.CRI Multiline Parsing

Containerd reads container stdout/stderr in **16KB chunks**. If a single log line exceeds 16KB, it splits it with `P` (partial) / `F` (final) tags:

```
2024-01-15T10:23:45.123Z stdout P {"level":"info","msg":"processing order","order_id":"abc
2024-01-15T10:23:45.123Z stdout P 123","items":[...continuing...more data...more data...mo
2024-01-15T10:23:45.123Z stdout F re data...]}
```

`multiline.parser: cri` buffers `P` chunks and emits one record on `F`. Without it, each chunk is a separate broken event.

> Note: this is not application-level multiline (e.g. stacktraces) — those need a separate multiline filter.