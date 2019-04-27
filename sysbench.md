# sysbench 
[参考资料](https://github.com/akopytov/sysbench)

## 安装
```
编译安装：
yum -y install make automake libtool pkgconfig libaio-devel mariadb-devel openssl-devel postgresql-devel
git clone https://github.com/akopytov/sysbench.git
./autogen.sh
# Add --with-pgsql to build with PostgreSQL support
./configure
make -j
make install

yum安装
curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.rpm.sh | sudo bash
sudo yum -y install sysbench

```
## 使用

```

/usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua    --mysql-host=192.168.5.51 --mysql-port=3306 --mysql-user=sysbench --mysql-password=123456 --mysql-db=pressure   --tables=10 --table_size=10000 --mysql_storage_engine=Innodb cleanup
/usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua    --mysql-host=192.168.5.51 --mysql-port=3306 --mysql-user=sysbench --mysql-password=123456 --mysql-db=pressure --tables=10 --table_size=10000 --mysql_storage_engine=Innodb prepare
/usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua    --mysql-host=192.168.5.51 --mysql-port=3306 --mysql-user=sysbench --mysql-password=123456 --mysql-db=pressure --tables=10 --table_size=10000 --mysql_storage_engine=Innodb --threads=10 --time=100  --warmup-time=300 --report-interval=10 --rand-type=uniform run

相关参数请参考github文档
```

## 分析报表

```
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
## sysbench其它压测功能
[其它测试](http://wangshengzhuang.com/2017/05/22/%E6%95%B0%E6%8D%AE%E5%BA%93%E7%9B%B8%E5%85%B3/MySQL/%E6%80%A7%E8%83%BD%E6%B5%8B%E8%AF%95/Sysbench%E8%BF%9B%E8%A1%8CCPU%20%E5%86%85%E5%AD%98%20IO%20%E7%BA%BF%E7%A8%8B%20mutex%E6%B5%8B%E8%AF%95%E4%BE%8B%E5%AD%90/)


