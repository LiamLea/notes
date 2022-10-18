# performance

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [performance](#performance)
    - [测试性能](#测试性能)
      - [1.测试rados性能](#1测试rados性能)
        - [（1）测试吞吐量](#1测试吞吐量)
        - [（2）测试延迟（一次I/O大小为4M）](#2测试延迟一次io大小为4m)
      - [2.查看osd的延迟](#2查看osd的延迟)

<!-- /code_chunk_output -->

### 测试性能

#### 1.测试rados性能

##### （1）测试吞吐量

* 命令

```shell
rados bench -p <pool> 10 write
```

* 结果
```shell
hints = 1
Maintaining 16 concurrent writes of 4194304 bytes to objects of size 4194304 for up to 10 seconds or 0 objects
Object prefix: benchmark_data_host-1_1617
  sec Cur ops   started  finished  avg MB/s  cur MB/s last lat(s)  avg lat(s)
    0       0         0         0         0         0           -           0
    1      16       156       140   559.964       560   0.0269844    0.111989
    2      16       281       265   529.933       500   0.0268183    0.117061
    3      16       408       392   522.586       508   0.0137911    0.117837
    4      16       555       539   538.912       588   0.0153584    0.117981
    5      16       681       665    531.91       504    0.188689    0.118279
    6      16       814       798   531.908       532   0.0147106    0.117745
    7      16       969       953   544.476       620   0.0220798    0.116901
    8      16      1104      1088   543.904       540     0.16947    0.116609
    9      16      1233      1217   540.791       516    0.134612    0.116745
   10      16      1383      1367     546.7       600    0.154328    0.116639
Total time run:         10.1106
Total writes made:      1384
Write size:             4194304
Object size:            4194304
Bandwidth (MB/sec):     547.542
Stddev Bandwidth:       43.207
Max bandwidth (MB/sec): 620
Min bandwidth (MB/sec): 500
Average IOPS:           136
Stddev IOPS:            10.8017
Max IOPS:               155
Min IOPS:               125
Average Latency(s):     0.11686
Stddev Latency(s):      0.056166
Max latency(s):         0.219823
Min latency(s):         0.0117409
Cleaning up (deleting benchmark objects)
Removed 1384 objects
Clean up completed and total clean up time :0.526881
```

* 结果分析
  * 观察`avg MB/s`或者`Bandwidth`，就是吞吐量

##### （2）测试延迟（一次I/O大小为4M）

* 命令

```shell
rados bench -t 1 -p <pool> 10 write
```

* 结果

```
hints = 1
Maintaining 1 concurrent writes of 4194304 bytes to objects of size 4194304 for up to 10 seconds or 0 objects
Object prefix: benchmark_data_host-1_1387
  sec Cur ops   started  finished  avg MB/s  cur MB/s last lat(s)  avg lat(s)
    0       0         0         0         0         0           -           0
    1       1        49        48   191.954       192   0.0223325   0.0207284
    2       1        99        98   195.961       200   0.0220773   0.0203272
    3       1       150       149    198.63       204   0.0214833   0.0201097
    4       1       204       203   202.963       216   0.0210082   0.0196469
    5       1       252       251   200.763       192    0.022244   0.0198552
    6       1       305       304    202.63       212    0.020824   0.0196934
    7       1       356       355    202.82       204   0.0136598   0.0196694
    8       1       408       407   203.463       208   0.0136694   0.0196471
    9       1       459       458   203.518       204   0.0211206   0.0196273
   10       1       510       509   203.564       204   0.0198964   0.0196124
Total time run:         10.0172
Total writes made:      511
Write size:             4194304
Object size:            4194304
Bandwidth (MB/sec):     204.05
Stddev Bandwidth:       7.6478
Max bandwidth (MB/sec): 216
Min bandwidth (MB/sec): 192
Average IOPS:           51
Stddev IOPS:            1.91195
Max IOPS:               54
Min IOPS:               48
Average Latency(s):     0.0196011
Stddev Latency(s):      0.00341557
Max latency(s):         0.0292501
Min latency(s):         0.01319
Cleaning up (deleting benchmark objects)
Removed 511 objects
Clean up completed and total clean up time :2.13525
```

* 结果分析
  * 观察`Average Latency`，就是延迟

#### 2.查看osd的延迟
能够定位到具体的osd
```shell
ceph osd perf
```
