# hardware

[toc]

### 查看硬盘信息: `smartctl`
* 需要安装: smartmontools
```shell
smartctl -a /dev/sda
```
```
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-18-amd64] (local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     KINGSTON SA400S37480G
Serial Number:    50026B7381471362
LU WWN Device Id: 5 0026b7 381471362
Firmware Version: 03180000
User Capacity:    480,103,981,056 bytes [480 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-3 T13/2161-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Sep 30 10:08:06 2022 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
...

SMART Error Log not supported

SMART Self-test Log not supported

Selective Self-tests/Logging not supported

```
