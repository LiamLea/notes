
innoDB buffer pool

1.innodb buffer pool
  innodb存储引擎把 数据页和索引页等 缓存在内存中，该内存区域称为缓冲池
  基本单位是page，页的大小为Innodb_page_size（16583B，可以在mysql变量中查看）

2.innodb_buffer_pool_pages_total
  innodb缓冲池的总页数，即能够计算出使用了多少内存空间
  total=free+data+misc

3.innodb_buffer_pool_pages_free
  innodb缓冲池中的空闲页数，即有多少页是没有使用的

4.innodb_buffer_pool_pages_data
  innodb缓冲池中的数据页数，包括脏页、干净页和索引页，即所有有数据的页数

5.innodb_buffer_pool_pages_misc
  innodb缓冲池中的用于管理的页数

6.innodb_buffer_pool_pages_dirty
  innodb缓冲池中的脏页数量，即被修改的页数，需要flush到磁盘

7.innodb_buffer_pool_read_requests
  innodb缓冲池中读请求的数量，即从该缓冲池中读取了多少次，即命中的次数

8.innodb_buffer_pool_write_requests
  innodb缓冲池中写请求的数量，即在该缓冲池中写入了多少次

9.innodb_buffer_pool_reads
  innodb引擎从磁盘读取的次数，即当读写请求需要操作的数据不在缓冲池内，innodb引擎就会跳过缓冲池，去磁盘直接读取

因此缓冲的命中率= innodb_buffer_pool_read_requests /（innodb_buffer_pool_read_requests+innodb_buffer_pool_reads）* 100
