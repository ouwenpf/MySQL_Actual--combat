# 理解binlog

- 根据日志定义的格式不一样可以分成：statement(SBR)，Row(RBR)或者MTXED格式
- 记录最新单位是一个Event，日志前4个字节是一个magic number(0xbin)，接下来19个字节记录Format desc event：FDE
- 一个事物由多个event组成如：
	- BEGIN
	- Table_map
	- Write_rows
	- Xid
	- COMMIT
- binlog包含：binary log和binary log index文件

# 复制中记录binlog格式

MySQL中使用row格式进行复制，原因如下：
- statement格式复制的优缺点
	- 优点：
		- 基于语句级别的复制binlog_format=statement
		- binlog文件较小
		- binlog方便阅读，方便故障修复
	- ***缺点***：
		- ***存在安全隐患，可能导致主从不一致的***
		- ***对一些系统函数不能准确复制或者不能复制，MySQL5.1抛弃了statement格式***
			- load_file()
			- uuid()
			- user()
			- sysdate() 
			
- row格式复制的优缺点：
	- 优点：
		- 相比statement格式更加安全binlog_format=row
		- 在某些情况下复制速度更快(sql复杂，表有主键)、
		- 系统的特殊函数也能够复制
		- 更少的锁
	- 缺点：
		- binary log比较大
		- 单语句更新(删除)表的行数量过多，会形成大量的binlog
		- 无法从bin_log看见用户执行的sql(binlog_row_query_log_events记录用户的query)

- mixed格式：
	- 此种格式属于一个过渡的格式
	- MySQL很多版本的新特性都是针对row+gtid，所以不要使用这种格式，没有太多的价值
	
# row格式binlog执行流程
![](images/复制技术变革1.jpg)  
master把更新内容写到binlog里面-->  
dump_thread唤醒IO_thread告诉我有更新了-->  
IO_thread把日志拉取到本地放到relay(供SQL_thread进行重放)日志中-->  
SQl_thread读取relay日志会查看语句有没有主键-->用主键匹配记录更新数据库  
没有主键查是否有二级索引-->利用第一个最长(字符类型的字节数)的索引匹配(内部隐藏  的rowid)
5.6每次全表扫描，5.7做了优化(第一次做全表扫描生成hash索引，以后走hash索引进行更新，重启丢失)   

# GTID用于解决什么问题

GTID：为每个事务进行唯一的编号  
- 主机和从库上分别产生了多少个事务 
- 这个事务是谁产生的


# 半同步

MySQL5.5和5.6中使用的机制  
![](images/复制技术变革2.jpg)  



**出现问题**：同一个时刻在主从读取的数据不一样(数据不一致性读 ) [事务隔离级别](https://blog.csdn.net/qq_34569497/article/details/79064208)  
![](images/复制技术变革3.jpg) 

# 增强半同步
mysql5.7中，淘宝周振兴提出  
![](images/复制技术变革4.jpg)  
mysql起来扫描redo，看处于prepare状态的Xid，拿到Xid去扫描最后一个binlog，存在，则该事务已经写完binlog，只不过还没有来得及写binlog filename position到redo，直接commit；否则就没有写完binlog就回滚