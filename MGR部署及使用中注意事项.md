# MGR环境部署

如果要使用MGR，强烈推荐MySQL8.0，其原因是因为官方主要保障的特性为MGR，如果有bug官方主要在8.0中进行修复，5.7中如果使用请使用5.7.22及以上的版本，MGR快速切换，数据一致性好，并行写入等特点



## 基本配置

```
#### for group_replication  
binlog_checksum=NONE  
transaction_write_set_extraction=XXHASH64  
loose-group_replication_group_name="3db33b36-0e51-409f-a61d-c99756e90155"  
loose-group_replication_start_on_boot=off
loose-group_replication_local_address= "172.18.0.11:23306"
loose-group_replication_group_seeds= "172.18.0.11:23306,172.18.0.12:23306,172.18.0.12:23307"
loose-group_replication_bootstrap_group= off
#loose-group_replication_single_primary_mode=off
#loose-group_replication_enforce_update_everywhere_checks=on
以上参数直接加入我所提供的my.cnf文件中，最后两行是否开放mutil-master模式

--启动mysql后，
set sql_log_bin=0;
create user 'repl'@'172.18.0.0/255.255.255.0' identified by '123456';  
grant replication slave on *.* to 'repl'@'172.18.0.0/255.255.255.0';   
set sql_log_bin=1;
change master to master_user='repl', master_password='123456' for channel 'group_replication_recovery';  
install plugin group_replication soname 'group_replication.so';  
show plugins;查询加载的插件
set global group_replication_bootstrap_group=on;注意只是开始的第一个节点  
start group_replication;   
select  * from performance_schema.replication_group_members;查询节点成员
```
目前支持9个节点，server_id=1-9，不能增多的原因是因为MGR有写放大，在一个节点上写入，再其它节点上也需要同时写入，写入的时候有个回包的过程，如果节点太多，回包也会很多，整个机器吞吐量下降，容易发生timeout超时，使集群容易崩溃。

## MGR工作的两种模式

- single-master
在MGR配置中，默认的模式是single-master模式，在此模式中，只有一个节点可以进行写人，其它节点都是自动开启read-only模式。  
	- 查询主节点  
	select variable\_value from performance\_schema.global\_status where variable\_name='group\_replication\_primary\_member';
	
- multi-master  

```
loose-group_replication_single_primary_mode=off
loose-group_replication_enforce_update_everywhere_checks=on
加入节点重启即可
```

- 生产环境中怎么选型
	- single-master  
	优点：
		1. 官方推荐使用single-master，且性能比multi-master高出15%性能提升    
		2. 由于单节点写入，防止了锁之间的冲突
	缺点：
		1. 面临选主的问题

	- multi-master  
	优点：
		1. 多节点随意写入
		2. 节点utid分区段写入，很好的解决了锁冲突的 问题
		3. 选主方便
	缺点：
		1. 更新数据丢失
		
single-master模式：有proxysql，面向开发，架构师选择此种模式  
multi-master模式：运维dba一般选择此种模式  
总结：业界不管是哪种都采用单节点写入，防止更新数据丢失的现象  




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

