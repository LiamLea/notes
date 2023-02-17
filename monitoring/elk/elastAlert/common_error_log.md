
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
Feb 17 06:40:40 host-2 kernel: [4647184.453701] EDAC MC0: 1 CE memory read error on CPU_SrcID#1_Ha#0_Chan#0_DIMM#0 (channel:0 slot:0 page:0x1223085 offset:0x7c0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:1 ha:0 channel_mask:1 rank:1)
```

```shell
#query_system_too_many_openfiles
Feb  6 14:01:01 master-1 systemd: HTTP: Accept error: accept tcp [::]:<port_number>: accept4: too many open files.
```
