# MySQL专业环境安装

## MySQL下载

MySQL下载唯一合法途径就是去官方下载，其它网上来源均不安全，作为dba人员请务必注意，推荐下载二进制包  
[下载地址](https://dev.mysql.com/downloads/mysql/)



## 安装前准备

- 关闭numa  
```
关闭numa：bios设置--memory setting--node interleaving设置enabled
numactl --hardware 查询numa是否开启
numactl --interleave=all mysqld --defaults-file=/data/mysql/mysql3306/my.cnf & 系统运行后不能进行BIOS操作可以采取此办法启动mysql

```

- 限制设置/etc/security/limits.conf && 网络优化

```
echo "*                -       nofile          65535" >>/etc/security/limits.conf
echo "*                -       nproc          65535" >>/etc/security/limits.conf
echo 'DefaultLimitNOFILE=65535' >>/etc/systemd/system.conf
echo 'DefaultLimitNPROC=65535' >>/etc/systemd/system.conf

net.ipv4.tcp_max_syn_backlog = 819200
net.core.netdev_max_backlog = 500000
net.core.somaxconn = 4096
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_tw_recycle = 0快速关闭，在直接对外服务器是一定不能打开的(经过net上网的不能保证每个客户端机器的时间是一致的)，内网可以打开
```
- IO调度
```
deadline(机械硬盘)
noop(ssd磁盘)
echo deadline|noop >/sys/block/sda/queue/scheduler
```
- 文件系统
```
xfs强烈推荐
ext4备选
```
- kernel
```
vm.swappiness=5 该配置用于控制系统将内存swap out到交换空间的积极性，取值范围是[0, 100]。swappiness越大，系统的交换积极性越高，默认是60
vm.dirty_background_ratio=5	脏数据占整个物理内存的百分比
vm.dirty_ratio=10	脏数据占单个内存的比分比
```
- selinux && iptables


## MySQL一键安装
	
[5.7脚本](scripts/2-MySQL专业安装/MySQL5.7_install.sh)  
[8.0脚本](scripts/2-MySQL专业安装/MySQL8.0_install.sh) 


## 专业的启动方式

	mysqld --defaults-file=/data/mysql/mysql3306/my.cnf &
	

### 客户端本地socke连接
```
mysql -S /tmp/mysql3306.sock
或者
mysql --defaults-file=/data/mysql/mysql3306/my.cnf -S /tmp/mysql3306.sock
mysqladmin -S /tmp/mysql3306.sock shutdown
mysql默认启动配置文件的加载顺序，mysqld读取配置文件中[mysqld]中部分，mysql读取配置文件中[mysql]和[client]中部分
/etc/my.cnf /etc/mysql/my.cnf /usr/local/mysql/etc/my.cnf ~/.my.cnf
```

### 账户安全加固

```
低于5.7版本进行账户加固处理：
mysql>delete from mysql.user where user!='root' or host!='localhost';
mysql>truncate mysql.db;
mysql>drop database test;
```

### 初始化故障排查

```
1. 库文件缺失，ldd /usr/local/mysql/bin/mysqld
2. 目录权限/data/mysql/mysql3306
3. datadir为非空
4. 磁盘空间不够df -h
5. 错误参数，重点查询error.log文件
6. selinux没有关闭

```


