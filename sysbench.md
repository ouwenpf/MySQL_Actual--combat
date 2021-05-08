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
# sysbench --help
        Usage:
            sysbench [options]... [testname] [command]
             
        Commands implemented by most tests: prepare run cleanup help
        sysbench 压测需要 3 个步骤：
        prepare(准备数据) -> run(运行测试) -> cleanup(清理数据)
        General options:
             --threads=N                    #创建测试线程的数量，默认值为 1
             --events=N                    #限制事件的总数量，0 表示不限制，默认值为 0
             --time=N                        #限制总共执行多长时间，单位是秒，默认是 10
             --forced-shutdown=STRING        #超过--time 后，等待多长时间强制关闭，单位是秒，默认 off
             --thread-stack-size=SIZE        #每个线程的堆大小，默认是 64k
             --rate=N                        #平均事务率，0 表示不限制
             --report-interval=N            #定期报告统计数据的时间间隔，单位秒，默认为 0，表示不显示中间报告。
              --report-checkpoints=[LIST,...]    #转储完整的统计信息并在指定的时间点重置所有计数器。默认为关闭
              --config-file=FILENAME        #可以把命令参数写到一个文件中，指定这个文件
		    --delete_inserts                每个事务包含delete和insert的个数，默认值1


            mysql options:
              --mysql-host=[LIST,...]        #  MySQL 服务器地址 ，默认 localhost
              --mysql-port=[LIST,...]        # MySQL 服务器端口 ，默认 3306
              --mysql-socket=[LIST,...]        # MySQL socket 文件
              --mysql-user=STRING            # MySQL user 默认 sbtest
              --mysql-password=STRING        # MySQL password 默认为空
              --mysql-db=STRING                # MySQL database name 默认 sbtest
              --mysql-compression[=on|off]    #是否使用压缩，默认为 off


/usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua    --mysql-host=10.0.8.14 --mysql-port=3306 --mysql-user=sysbench --mysql-password=123456 --mysql-db=pressure   --tables=10 --table_size=10000 --mysql_storage_engine=Innodb cleanup
/usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua    --mysql-host=10.0.8.14 --mysql-port=3306 --mysql-user=sysbench --mysql-password=123456 --mysql-db=pressure --tables=10 --table_size=10000 --mysql_storage_engine=Innodb prepare
/usr/local/bin/sysbench  /usr/local/share/sysbench/oltp_read_write.lua    --mysql-host=10.0.8.14 --mysql-port=3306 --mysql-user=sysbench --mysql-password=123456 --mysql-db=pressure --tables=10 --table_size=10000 --mysql_storage_engine=Innodb --threads=10 --time=100  --warmup-time=300 --report-interval=10 --rand-type=uniform run

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
















