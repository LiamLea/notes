### Network Performance Tuning

* Increase the maximum number of TCP connections
```shell
sysctl -w net.ipv4.ip_local_port_range="1024 65535"
```

* Enable TCP Fast Open
```shell
sysctl -w net.ipv4.tcp_fastopen=3
```

* Adjust TCP Keepalive Intervals
```shell
sysctl -w net.ipv4.tcp_keepalive_time=600 sysctl -w net.ipv4.tcp_keepalive_probes=5 sysctl -w net.ipv4.tcp_keepalive_intvl=15
```

### Security Enhancements
* Disable IP Forwarding
```shell
sysctl -w net.ipv4.ip_forward=0
```

* Enable SYN Cookies (Prevent SYN flood)
    * Protects against SYN flood attacks, enhancing the system’s resilience to certain denial-of-service attacks.
```shell
sysctl -w net.ipv4.tcp_syncookies=1
```

* Prevent ICMP Broadcast Echo Requests
```shell
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
```

### System Performance Optimization

* Control Swappiness
    * This decreases the kernel’s tendency to use swap, beneficial for systems with sufficient memory.
```shell
sysctl -w vm.swappiness=10
```

* Increase File Descriptor Limits
```shell
sysctl -w fs.file-max=2097152
```

* Adjust the Dirty Background Ratio
    * Determines the threshold of system memory usage with “dirty” pages before commencing background disk writes, impacting write-intensive operations.
```shell
sysctl -w vm.dirty_background_ratio=5
```

### System Stability and Logging
* Set Kernel Panic Behavior
    * Configures the system to reboot automatically 10 seconds after a kernel panic, assisting in recovery from critical errors
```shell
sysctl -w kernel.panic=10
```