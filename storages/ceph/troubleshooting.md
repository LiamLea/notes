# troubleshooting

[toc]

### 常见问题

#### 1.osd crash（无法启动）
可以在osd up的时候，可以把该osd剔除集群（ceph osd out <osd_id>），等数据同步完，再加入集群
