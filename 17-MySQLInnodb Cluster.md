# MySQLInnodb Cluster搭建   

如果要使用MGR，强烈推荐MySQL8.0，其原因是因为官方主要保障的特性为MGR，如果有bug官方主要在8.0中进行修复，5.7中如果使用请使用5.7.22及以上的版本，MGR快速切换，数据一致性好，并行写入等特点  
目前业界靠谱的两种方案:GTID+ROW+并行复制+增强半同步,MGR(MySQL Innodb Cluster)


## 基本配置

```
####for test
read_only=1
super_read_only=1
sync_binlog=0
innodb_flush_log_at_trx_commit=2 
sync_relay_log=0


####:for clone_plugin
plugin-load-add=mysql_clone.so
sql_require_primary_key                         =ON
explicit_defaults_for_timestamp                 =ON
mysqlx_port                                     =33060

###:for MGR
slave_preserve_commit_order=1
group_replication_compression_threshold=2000000
transaction_write_set_extraction=XXHASH64  
loose-group_replication_group_name="3db33b36-0e51-409f-a61d-c99756e90155"  
loose-group_replication_start_on_boot=off  
loose-group_replication_local_address= "10.0.8.14:23306"
loose-group_replication_group_seeds= "10.0.8.11:23306,10.0.8.12:23306,10.0.8.13:23306"
loose-group_replication_bootstrap_group= off
#multi-master 
#loose-group_replication_single_primary_mode=off
#loose-group_replication_enforce_update_everywhere_checks=on

注意:需要用用到clone_plugin,和clone相关的参数也要配置好,hosts文件也 需要配置好,否则集群无法创建;创建相应的账户
create user 'cluster'@'10.0.8.%' identified by '123456';
GRANT ALL  on *.* to 'cluster'@'10.0.8.%'  with grant option;
如果出现加入不了集群清空reset slave all
```

## Mysqlshell快速部署MySQLInnodb Cluster


```
1. mysqlshell运行后
\help查询相关帮助信息(语法为反斜线开头)
 - dba     Used for InnoDB cluster administration.
 - mysql   Support for connecting to MySQL servers using the classic MySQL
           protocol.
 - mysqlx  Used to work with X Protocol sessions using the MySQL X DevAPI.
 - os      Gives access to functions which allow to interact with the operating
           system.
 - plugins Plugin to manage MySQL Shell plugins
 - session Represents the currently open MySQL session.
 - shell   Gives access to general purpose functions and properties.
 - sys     Gives access to system specific parameters.
 - util    Global object that groumiscellaneous tools like upgrade checker
           and JSON import.
 
 2.  dba.help()查询dba下面的操作信息,mysql,shell,sys等相关操作均可以通过此方法查询帮助信息
 如:  创建MySQL InnoDB cluster相关接口就这此dba下
 createCluster(name[, options])
            Creates a MySQL InnoDB cluster.
 shell.help()查询到连接到MySQL InnoDB cluster中的节点
 \connect  cluster@10.0.8.14:3306
 模式切换:\js   \sql此模式下可以运行sql语句
 3. 创建MySQL InnoDB cluster
 定义变量按照官方提供:         
var cluster=dba.createCluster('testCluster')创建
cluster.help()查询帮助
var cluster=dba.getCluster('testCluster')退出后重新进入,加载
cluster.addInstance('cluster@10.0.8.14:3306')主节点加入,其它节点也通过此命令添加
cluster.rejoinInstance('cluster@10.0.8.14:3306')重新加入
cluster.removeInstance('cluster@10.0.8.14:3306')移除节点
cluster.rescan()扫描错误节点,予以删除

节点挂了从新加入如果加入失败
stop group_replication;
dba.dropMetadataSchema();  
reset slave all;

cluster.status()查询节点状态

- ONLINE       - 节点状态正常。
- OFFLINE      - 实例在运行，但没有加入任何Cluster。
- RECOVERING   - 实例已加入Cluster，正在同步数据。
- ERROR        - 同步数据发生异常。
- UNREACHABLE  - 与其他节点通讯中断，可能是网络问题，可能是节点crash。
- MISSING      - 节点已加入集群，但未启动group replication yttrr000

日常使用的几个重要命令 (mysqlsh的JS语法)
dba.checkInstanceConfiguration('cluster@10.0.8.14:3306')     #检查节点配置实例，用于加入cluster之前
   
dba.rebootClusterFromCompleteOutage('myCluster');        #重启 
 
dba.dropMetadataSchema();                                #删除schema
stop group_replication
 
var cluster = dba.getCluster('myCluster')                #获取当前集群
 
cluster.checkInstanceState('cluster@10.0.8.14:3306')         #检查cluster里节点状态
 
cluster.rejoinInstance('cluster@10.0.8.14:3306')             #重新加入节点，我本地测试的时候发现rejoin一直无效，每次是delete后
 
addcluster.dissolve({force：true})                       #删除集群
 
cluster.addInstance('cluster@10.0.8.14:3306')                #增加节点
 
cluster.removeInstance('cluster@10.0.8.14:3306')             #删除节点
 
cluster.removeInstance('cluster@10.0.8.14:3306',{force:true})    #强制删除节点
 
cluster.dissolve({force:true})                           #解散集群
 
cluster.describe();                                      #集群描述
```



##mysqlroute搭建
```
mysqlroute基于端口的读写分离,官方提供很稳定
mysqlrouter  --bootstrap  cluster@10.0.8.14:3306 -d   /data/mysqlrouter  --user=mysql 
sh  start
mysqlrouter -c  /data/mysqlrouter/mysqlrouter.conf & 也可以相应的启动
在/data/mysqlrouter自动生成相应的配置文件
├── data
│   ├── ca-key.pem
│   ├── ca.pem
│   ├── keyring
│   ├── router-cert.pem
│   ├── router-key.pem
│   └── state.json
├── log
│   └── mysqlrouter.log
├── mysqlrouter.conf
├── mysqlrouter.key
├── mysqlrouter.pid
├── run
├── start.sh
└── stop.sh


mysql -h10.0.8.50  -p123456 -usysbench -P6446 即可登录 注意:需要配置好hosts文件
```



## 监控

- 可用节点  
	`select member_state  from performance_schema.replication_group_members where member_id=@@server_uuid;`   
- 当前节点是否可写入  
	`select * from performance_schema.global_variables where variable_name in ('read_only','super_read_only');` 
- 延迟   
	`远程获取gtid信息：select RECEIVED_TRANSACTION_SET from performance_schema.replication_connection_status where CHANNEL_NAME='group_replication_applier';`  
	`本节点：select @@gtid_executed;`  
- 队列是否有堆积	
	`select count_transactions_in_queue from performance_schema.replication_group_member_stats where member_id=@ember_id=@@server_uuid;`  

	远程获取GTID - 本节点GTID = 延迟的GTID



## 流控

```
group_replication_flow_control_mode=QUOTA  
group_replication_flow_control_applier_threshold(默认：25000)
group_replication_flow_control_certifier_threshold(默认：25000)  
set global group_replication_flow_control_mode='disabled';  

注意：流控默认不要关闭，在备份恢复，新节点加入(gtid相差很多的时候)，可用关闭流控
```

## GMR使用注意事项

- 模式选择
	- 多主模式
	- 单主模式
- 大事务控制
	- 事务拆分
	- 在不同节点更新同一条数据
- 备份及新节点加入


## mysqlroute