
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [linux](#linux)

<!-- /code_chunk_output -->

### linux

* kernel
```shell
#query_OOM
Feb  6 14:01:01 kernel: Out of memory: Kill process 9163 (mysqld) score 511 or sacrifice child

#query_kernel_error

#query_hardware_memory_error
EDAC MC0: 5450 CE error on CPU#0Channel#1_DIMM#0 (channel:1 slot:0
```

```shell
#query_system_too_many_openfiles
Feb  6 14:01:01 master-1 systemd: HTTP: Accept error: accept tcp [::]:<port_number>: accept4: too many open files.
```
