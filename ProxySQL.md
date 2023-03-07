#ProxySQL

##配置管理
[下载地址](https://github.com/sysown/proxysql/releases)   
[参考资料](https://github.com/sysown/proxysql)   
[参考资料](https://blog.51cto.com/sumongodb/2130453)   
[参考资料](https://proxysql.com/)   
[参考资料](http://idber.github.io/2018/08/28-ProxySQL%20%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE%E8%AF%A6%E8%A7%A3%E5%8F%8A%E8%AF%BB%E5%86%99%E5%88%86%E7%A6%BB%E3%80%81%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1.html)



###安装
```
1.https://github.com/sysown/proxysql/releases下载最新的版本
2. yum localinstall  -y  proxysql.rpm 安装最新的包
3. systemctl start proxysql(建议修改配置文件,使用proxysql  -c /data/proxysql/proxysql.cnf  > /dev/null 2>&1 & 
方式启动)
启动成功后：默认监听6032和6033,6032为后台管理端口，6033默认对外服务端口

```




###连接ProxySQL
```
ProxySQL默认管理端口6032，默认需要127.0.0.1来进入，进入方式和连接MySQL方式一致
mysql -uadmin -h127.0.0.1 -padmin -P6032
```

###核心配置表

```
 每个这样的表都有明确的定义：

mysql_servers:包含要连接的ProxySQL的后端服务器列表

mysql_users:包含ProxySQL将用于向后端服务器进行身份验证的用户列表

mysql_query_rules:包含用于缓存，路由或重写发送到ProxySQL的SQL查询的规则

global_variables:包含在服务器初始配置期间定义的MySQL变量和管理变量
```

###在不同层级间移动配置信息
![](images/19-proxysql/proxysql01.jpg)

```
常用的命令参考：
LOAD MYSQL USERS TO RUNTIME;
SAVE MYSQL USERS TO DISK;

LOAD MYSQL SERVERS TO RUNTIME;
SAVE MYSQL SERVERS TO DISK;

LOAD MYSQL QUERY RULES TO RUNTIME;
SAVE MYSQL QUERY RULES TO DISK;

LOAD MYSQL VARIABLES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;

LOAD ADMIN VARIABLES TO RUNTIME;
SAVE ADMIN VARIABLES TO DISK;

注意：关键字MEMORY/RUNTIME 都支持缩写：
   MEM for MEMORY
   RUN for RUNTIME

```

###核心表中核心字段说明

```

1. 限制ProxySQL到后端MySQL的连接数通过权重，来控制ProxySQL到后端MySQL的访问量
    
    
```
###读写分离
```

配置监控账户,需要先在mysql主库设置
set mysql-monitor_username='monitor';
set mysql-monitor_password='monitor';
load mysql variables to runtime;
save mysql variables to disk;

insert into mysql_replication_hostgroups(writer_hostgroup,reader_hostgroup,comment) values (1,2,'proxysql');
insert into mysql_servers(hostgroup_id,hostname,port,max_connections,comment) values (1,'127.0.0.1',3306,5000,'master'),(2,'127.0.0.1',3307,5000,'slave'),(2,'127.0.0.1',3308,5000,'slave');
load mysql servers to runtime;
save mysql servers to disk;

insert into mysql_users(username,password,default_hostgroup) values ('sysbench','123456',1);
load mysql users to runtime;
save mysql users to disk;


insert into mysql_query_rules (rule_id,active,username,schemaname, client_addr,match_digest,destination_hostgroup,flagIN, flagOUT,log,apply) values(1,1,NULL,NULL,NULL,'.',NULL,0,NULL,1,0);
insert into mysql_query_rules(rule_id,active,match_pattern,destination_hostgroup, apply) VALUES(1,1,'^SELECT.*FOR UPDATE$',1,1);
insert into mysql_query_rules(rule_id,active,match_pattern,destination_hostgroup, apply) VALUES(2,1,'^SELECT',2,1);
insert into mysql_query_rules(rule_id,active,match_pattern,destination_hostgroup, apply) VALUES(3,1,'^show slave status',2,1);


load mysql query rules to runtime;
save mysql  query rules to disk;


设置开启全日志

update global_variables set variable_value=1 where
variable_name='mysql-eventslog_default_log';
设置为json的日志格式

update global_variables set variable_value=2 where
variable_name='mysql-eventslog_format';      
设置日志文件名

update global_variables set variable_value='query.log' where
variable_name='mysql-eventslog_filename';

load mysql variables to runtime;
save mysql variables to disk;
设置隔离级别
set mysql-default_tx_isolation='REPEATBALE READ';


设置字符集
set mysql-default_charset='utf8mb4';

load mysql variables to runtime;
save mysql variables to disk;


设置远程管理账户，默认只能是本地
set admin-admin_credentials = "admin:admin;radmin:radmin"
load admin variables to runtime;
save admin variables to disk;

```
###重要的表信息
```
stats_mysql_query_digest:sql归一化记录，可以统计出每个sql语句查询的次数



```


###缓存
```
mysql_query_rules(rule_id,active,digest,destination_hostgroup, cache_ttl,apply) VALUES(4,1,'0xC6DC4F136BB45F8E',100,10000,1);  
根据stats_mysql_query_digest中的digest字段hash值进行缓存
```
###连接池



###注意事项
- mysql_users连接数是ProxySQL对外提供的连接数，可以大一点没事
- mysql_servers里的连接数是ProxySQL内一个用户可以创建连接数，如果一个机器属于多个hostgroup_id里，注意这个值要小一点
- 实现工作ProxySQl可能是多台，注意别把MySQL的连接沾满

- mysql_query_rules
	- SQL改写
	- 指定SQL读写分离
	- 指定SQL cache
	



##proxysql+MGR
[存储过程下载地址](https://github.com/zhishutech/mysql_gr_routing_check.git)  
```
每个mysql节点导入存储过程addition_to_sys8.sql
group分组:
insert into mysql_group_replication_hostgroups (writer_hostgroup,backup_writer_hostgroup,reader_hostgroup,offline_hostgroup,max_writers, writer_is_also_reader ,max_transactions_behind,comment) 
values (100,101,102,103,1,0,100,'proxysql');

writer_hostgroup:写组
backup_writer_hostgroup:备用写组
reader_hostgroup:读组
offline_hostgroup:下线组
max_writers:最大可写数量
writer_is_also_reader:写节点是否可读
max_transactions_behind:最大延迟时间,超出这个时间就不发送达此节点




添加 mysql server 

insert into mysql_servers(hostgroup_id,hostname,port,max_connections) values (100,'10.0.8.11',3306,100),(102,'10.0.8.12',3306,100),(102,'10.0.8.12',3306,100);


添加用户

insert into mysql_users(username,password,default_hostgroup) values ('cluster','123456',100);
default_hostgroup:默认写组,这个一定要 注意

insert into mysql_query_rules(rule_id,active,match_pattern,destination_hostgroup, apply) VALUES(1,1,'^SELECT.*FOR UPDATE$',100,1);
insert into mysql_query_rules(rule_id,active,match_pattern,destination_hostgroup, apply) VALUES(2,1,'^SELECT',102,1);
insert into mysql_query_rules(rule_id,active,match_pattern,destination_hostgroup, apply) VALUES(3,1,'^show slave status',102,1);


load mysql servers to runtime;
load mysql users to runtime;
load mysql query rules to runtime;
save mysql  servers to disk;
save mysql  users  to disk;
save mysql  query rules to disk;
save mysql  variables   to disk;



```
