#ProxySQL

##配置管理
[参考资料](https://blog.51cto.com/sumongodb/2130453)   
[参考资料](http://idber.github.io/2018/08/28-ProxySQL%20%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE%E8%AF%A6%E8%A7%A3%E5%8F%8A%E8%AF%BB%E5%86%99%E5%88%86%E7%A6%BB%E3%80%81%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1.html)


###读写分离
```
insert into mysql_replication_hostgroups(writer_hostgroup,reader_hostgroup,comment) values (10,100,'proxysql');
insert into mysql_servers(hostgroup_id,hostname,port,max_connections) values (10,'172.18.0.11',3306,950),(10,'172.18.0.12',3306,950),(10,'172.18.0.13',3306,950);
load mysql servers to runtime;
save mysql servers to disk;

insert into mysql_users(username,password,default_hostgroup) values ('proxysql','123456',10);
load mysql users to runtime;
save mysql users to disk;


insert into mysql_query_rules(rule_id,active,match_pattern,destination_hostgroup, apply) VALUES(1,1,'^SELECT.*FOR UPDATE$',10,1);
insert into mysql_query_rules(rule_id,active,match_pattern,destination_hostgroup, apply) VALUES(2,1,'^SELECT',100,1);
insert into mysql_query_rules(rule_id,active,match_pattern,destination_hostgroup, apply) VALUES(3,1,'^show slave status',100,1);
match_pattern:正则匹配
load mysql query rules to runtime;
save mysql  query rules to disk;


设置远程管理账户，默认只能是本地
set admin-admin_credentials = "admin:admin;test:test"
load admin variables to runtime;
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