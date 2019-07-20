# MySQL常用的复制技术  

- 传统的异步复制
- 半同步复制
- 增强半同步
- 多源复制

本章内容带领大家一起动手，怎么搭建上述的复制技术，原理本章节暂不涉及

## 传统的异步复制

```
基于5.7.25或者8.0.15，row+gtid复制格式

环境说明：
	主机列表：
	主库：192.168.8.81
	从库：192.168.8.82
	从库：192.168.8.83
	MySQL版本：
		5.7.25或者8.0.15
		
搭建的目标：
1. 异步复制(新环境)
必开参数：
	binlog_format                       =row
	log_bin                             =/data/mysql/mysql3306/logs/mysql-bin                       
	gtid_mode                           =on 
	enforce_gtid_consistency            =on 
	server_id                           =123306建议IP最后一位+端口号

2. 建立复制账户
	create user 'repl'@'192.168.%.%' identified by 'XXXXXX';
	grant replication slave *.* on 'repl'@'192.168.%.%' ;
	reset master;新环境可以，其它禁止使用此命令

3. 从库上
	change master to master_host='172.18.0.11',master_port=3306,master_user='repl',master_password='xxxxxx',master_auto_position=1;gtid环境
	change master to master_host='172.18.0.11',master_port=3306,master_user='repl',master_password='xxxxxx',master_log_file='mysql-bin.000001', master_log_pos=155;非gtid环境

4. 启动
	start slave;
	
	
搭建的目标：
1. 异步复制(非新环境)，mysqldupm备份文件+row+gtid
必开参数：
	binlog_format                       =row
	log_bin                             =/data/mysql/mysql3306/logs/mysql-bin                       
	gtid_mode                           =on 
	enforce_gtid_consistency            =on 
	server_id                           =123306建议IP最后一位+端口号

2. 备份数据库
	mysqldump -hxxx  -uxxx -pxxx -A --single-transaction --master-data=2|gzip > all.sql.gz

3. 还原新的从库
	mysql -hxxx -uxxx -pxxx < all.sql

4. 建立复制账户
	create user 'repl'@'192.168.%.%' identified by 'XXXXXX';
	grant replication slave *.* on 'repl'@'192.168.%.%' ;
	reset master;新环境可以，其它禁止使用此命令

5. 从库上
	change master to master_host='172.18.0.11',master_port=3306,master_user='repl',master_password='xxxxxx',master_auto_position=1;gtid环境
	change master to master_host='172.18.0.11',master_port=3306,master_user='repl',master_password='xxxxxx',master_log_file='mysql-bin.00000x', master_log_pos=xxx;非gtid环境
注意：--master-data=1的时候，可以不用设置master_log_file='mysql-bin.00000x', master_log_pos=xxx，位置点在备份文件中可以相应找到
```



## 增强半同步

```
1. 首先确保异步复制结构是Ok

2. 主从都加载一下插件
INSTALL PLUGIN rpl_semi_sync_master SONAME 'semisync_master.so';
INSTALL PLUGIN rpl_semi_sync_slave SONAME 'semisync_slave.so';

3. 从库上执行
slave: 
SET GLOBAL rpl_semi_sync_slave_enabled = 1;
stop slave io_thread; start slave io_thread;

4. 主库上执行
set global rpl_semi_sync_master_enabled=1; 
set global rpl_semi_sync_master_timeout=N(毫秒); 
set global rpl_semi_sync_master_wait_for_slave_count=1; 

增强半同步需要注意的以下几个问题：
1)如果master上全部从库挂掉了，超时参数如果设置无穷大，主库hang住不能写入，可以临时禁用半同步，让master对外提供服务
2)如果拿一个备份新建一个从库，确认IO_thread追上主库后再开设半同步
3)金融环境是不允许退化成异步

5. 查询相应的参数和状态
show global variables  like '%sync%';
show global status  like '%sync%';
```


