# sysbench 
[sysbench下载](https://github.com/akopytov/sysbench)   
[sysbench源码](https://github.com/akopytov/sysbench/releases)
[参考资料](https://www.cnblogs.com/chenmh/p/5866058.html)
## 安装
```
编译安装：
yum -y install make automake libtool pkgconfig libaio-devel mariadb-devel openssl-devel postgresql-devel
git clone https://github.com/akopytov/sysbench.git
./autogen.sh
# Add --with-pgsql to build with PostgreSQL support
./configure  --with-pgsql
<<<<<<< HEAD
=======
#如果出现报错drv_mysql.c:420:24
#./configure --with-mysql-includes=/usr/local/mysql/include/    --with-pgsql


>>>>>>> fee5ff737456b8e86a2d7983b65eb49a1ff99014
make -j
make install

yum安装
curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.rpm.sh | sudo bash
sudo yum -y install sysbench

```
## 使用

```
# sysbench --help
--oltp-test-mode=STRING                    测试类型：simple(简单select测试),complex(事务测试),nontrx(非事务测试),sp(存储过程) ；默认complex
  --oltp-reconnect-mode=STRING             连接类型：session(每个线程到测试结束不重新连接),transaction(执行每个事务重新连接),query(每一个查询重新连接),random(随机)；默认 [session]
  --oltp-sp-name=STRING                    指定执行测试的存储过程名
  --oltp-read-only=[on|off]                仅执行select测试，默认关闭
  --oltp-avoid-deadlocks=[on|off]          更新过程中忽略死锁，默认[off]
  --oltp-skip-trx=[on|off]                 语句以bigin/commit开始结尾，默认[off]
  --oltp-range-size=N                      范围查询的范围大小，默认 [100]，例如begin 100 and 200
  --oltp-point-selects=N                   单个事务中select查询的数量，默认 [10]
  --oltp-use-in-statement=N                每个查询中主键查找(in 10个值)的数量，默认 [0]
  --oltp-simple-ranges=N                   单个事务中执行范围查询的数量(SELECT c  FROM sbtest WHERE id BETWEEN  N AND  M)，默认[1]
  --oltp-sum-ranges=N                      单个事务中执行范围sum查询的数量，默认 [1]
  --oltp-order-ranges=N                    单个事务中执行范围order by查询的数量，默认[1]
  --oltp-distinct-ranges=N                 单个事务中执行范围distinct查询的数量，默认[1]
  --oltp-index-updates=N                   单个事务中执行索引更新的操作的数量，默认[1]
  --oltp-non-index-updates=N               单个事务中执行非索引更新操作的数量，默认[1]
  --oltp-nontrx-mode=STRING                指定单独非事务测试类型进行测试，默认select {select, update_key, update_nokey, insert, delete} [select]
  --oltp-auto-inc=[on|off]                 id列默认自增，默认[on]
  --oltp-connect-delay=N                   指定每一次重新连接延时的时长，默认1秒 [10000]
  --oltp-user-delay-min=N                  minimum time in microseconds to sleep after each request [0]
  --oltp-user-delay-max=N                  maximum time in microseconds to sleep after each request [0]
  --oltp-table-name=STRING                 指定测试的表名，默认[sbtest]
  --oltp-table-size=N                      指定表的记录大小，默认[10000]
  --oltp-dist-type=STRING                  随机数分布状态。uniform(均匀分布)、gauss(高斯分布)、special(特殊分布)，默认 [special]
  --oltp-dist-iter=N                       number of iterations used for numbers generation [12]
  --oltp-dist-pct=N                        启用百分比特殊分布，默认 [1]
  --oltp-dist-res=N                        special 百分比[75]
  --oltp-point-select-mysql-handler=[on|off] Use MySQL HANDLER for point select [off]
  --oltp-point-select-all-cols=[on|off]    select查询测试时select所有列，默认[off]
  --oltp-secondary=[on|off]                索引不是主键索引而是二级索引，默认[off]
  --oltp-num-partitions=N                  指定表分区的数量，默认 [0]
  --oltp-num-tables=N                      指定测试表的数量，默认[1]
General database options:
  --db-driver=STRING  指定测试数据库类型，默认mysql
  --db-ps-mode=STRING prepared statements usage mode {auto, disable} [auto]

mysql options:
  --mysql-host=[LIST,...]       MySQL server host [localhost]
  --mysql-port=N                MySQL server port [3306]
  --mysql-socket=STRING         MySQL socket
  --mysql-user=STRING           MySQL user [sbtest]
  --mysql-password=STRING       MySQL password []
  --mysql-db=STRING             MySQL database name [sbtest]
  --mysql-table-engine=STRING   storage engine to use for the test table {myisam,innodb,bdb,heap,ndbcluster,federated} [innodb]
  --mysql-engine-trx=STRING     whether storage engine used is transactional or not {yes,no,auto} [auto]
  --mysql-ssl=[on|off]          use SSL connections, if available in the client library [off]
  --myisam-max-rows=N           max-rows parameter for MyISAM tables [1000000]
  --mysql-create-options=STRING additional options passed to CREATE TABLE []

oltp测试主要会有以下相关参数的测试,,其它相关参数默认即可，有需求也可以自定义：

--mysql-engine-trx=STRING     指定不同的存储引擎测试。
--oltp-test-mode=STRING       测试类型：simple(简单select测试),complex(事务测试),nontrx(非事务测试),sp(存储过程) ；默认complex
--oltp-sp-name=STRING         指定存储过程进行语句测试
--oltp-table-size=N           指定表的记录大小，默认[10000]
--oltp-num-tables=N           指定测试表的数量，默认[1]


create database pressure;
create user 'sysbench'@'%' identified by '123456';
grant all on pressure.* to   'sysbench'@'%' ;


/usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua    --mysql-host=10.0.8.14 --mysql-port=3306 --mysql-user=sysbench --mysql-password=123456 --mysql-db=pressure --tables=10 --table_size=10000 --threads=10 --mysql_storage_engine=Innodb prepare
/usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua    --mysql-host=10.0.8.14 --mysql-port=3306 --mysql-user=sysbench --mysql-password=123456 --mysql-db=pressure --tables=10 --table_size=10000 --threads=10 --mysql_storage_engine=Innodb prewarm
/usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua    --mysql-host=10.0.8.14 --mysql-port=3306 --mysql-user=sysbench --mysql-password=123456 --mysql-db=pressure --tables=10 --table_size=10000 --mysql_storage_engine=Innodb --threads=10 --time=100  --warmup-time=10 --report-interval=1 --rand-type=uniform run
/usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua    --mysql-host=10.0.8.14 --mysql-port=3306 --mysql-user=sysbench --mysql-password=123456 --mysql-db=pressure   --tables=10 --table_size=10000 --mysql_storage_engine=Innodb cleanup






/usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua --tables=10 --table-size=1000   --db-ps-mode=disable --db-driver=pgsql --pgsql-host=172.16.0.15  --report-interval=10 --pgsql-port=47001  --pgsql-user=abc --pgsql-password=abc --pgsql-db=postgres --threads=10   --time=300   cleanup 

/usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua --tables=10 --table-size=1000   --db-ps-mode=disable --db-driver=pgsql --pgsql-host=172.16.0.15  --report-interval=10 --pgsql-port=47001  --pgsql-user=abc --pgsql-password=abc --pgsql-db=postgres --threads=10   --time=300   prepare


 /usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua --tables=10 --table-size=1000 --db-ps-mode=disable --db-driver=pgsql --pgsql-host=172.16.0.15  --report-interval=10 --pgsql-port=5401 --pgsql-user=abc --pgsql-password=abc --pgsql-db=postgres --threads=1  --time=300 --rand-type=uniform run





相关参数请参考github文档
```


## 分析报表

```
[ 6s ] thds: 4 tps: 334.99 qps: 6712.77 (r/w/o: 4698.84/929.97/1083.96) lat (ms,95%): 19.65 err/s: 0.00 reconn/s: 0.00

[ 6s ]：表示当前已经压测6s。
thds: 4：表示4个线程并发压测。
tps: 334.99：表示在report-interval时间间隔内的每秒事务数。
qps: 6712.77：表示在report-interval时间间隔内的每秒查询数。
(r/w/o: 4698.84/929.97/1083.96)：表示在report-interval时间间隔内的每秒读/写/其他请求数，用于补充说明qps。
lat (ms,95%):19.65：表示在report-interval时间间隔内的请求95%的延迟时间在19.65ms以下。
err/s: 0.00：表示在report-interval时间间隔内的每秒失败请求数。
reconn/s: 0.00：表示在report-interval时间间隔内的每秒重连接数。




SQL statistics:
    queries performed:
        read:                            8726242//总select数量
        write:                           2493798//总update、insert、delete语句数量
        other:                           1246773//commit、unlock tables以及其他mutex的数量
        total:                           12466813
    transactions:                        623512 (173.17 per sec.)
    queries:                             12466813 (3462.46 per sec.)
    ignored errors:                      5      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

Throughput:
    events/s (eps):                      173.1704//每秒事务数
    time elapsed:                        3600.5779s//总时长
    total number of events:              623512

Latency (ms):
         min:                                   12.56
         avg:                                 1478.52
         max:                                11354.27
         95th percentile:                     2778.39//超过95%平均耗时，后面的95%的大小可以通过--percentile=98的方式去更改
         sum:                            921875222.94

Threads fairness:
    events (avg/stddev):           2435.5938/20.06
    execution time (avg/stddev):   3601.0751/0.19
    
    
    
    
    
    
    
    
    
    
    
    

```

## sysbench测试腾讯云TDSQL
![](images/sysbench/01.jpg)  

```
cp  oltp_common.lua  groupshard.lua
vim groupshard.lua

190    print(string.format("Creating table 'sbtest%d'...", table_num))
191    extra_table_options = extra_table_options .. " shardkey=id"        #添加一行

200       table_num, id_def, id_index_def, engine_def,
201       sysbench.opt.create_table_options)    #sysbench.opt.create_table_options修改为：extra_table_options

203    con:query(query)
204    con:query("select sleep(10)")                    #添加一行
210    if sysbench.opt.auto_inc then
211       query = "INSERT IGNORE INTO sbtest" .. table_num .. "(k, c, pad) VALUES"     #增加IGNORE
212    else
213       query = "INSERT IGNORE INTO sbtest" .. table_num .. "(id, k, c, pad) VALUES"  #增加IGNORE



/usr/local/bin/sysbench  /usr/local/share/sysbench/groupshard.lua    --mysql-host=172.16.5.2  --mysql-port=3306 --mysql-user=test --mysql-password=Gameads@2021  --mysql-db=test   --tables=10 --table_size=1000000 --mysql_storage_engine=Innodb cleanup

/usr/local/bin/sysbench  /usr/local/share/sysbench/groupshard.lua    --mysql-host=172.16.5.2  --mysql-port=3306 --mysql-user=test --mysql-password=Gameads@2021  --mysql-db=test   --tables=10 --table_size=1000000 --mysql_storage_engine=Innodb prepare

/usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua    --mysql-host=172.16.5.2 --mysql-port=3306 --mysql-user=test --mysql-password=Gameads@2021 --mysql-db=test --tables=10 --table_size=10000 --mysql_storage_engine=Innodb --threads=10 --time=100  --warmup-time=10 --report-interval=10 --rand-type=uniform run

```
## sysbench其它压测功能
[其它测试](https://www.iorisun.com/archives/705//)
https://www.cnblogs.com/ivictor/p/16955580.html
















