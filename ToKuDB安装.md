# ToKuDB插件安装


[参考资料](https://www.percona.com/doc/percona-server/5.6/tokudb/tokudb_installation.html)

- 前言

	下载Percona MySQL5.6版本，跟官方版本MySQL5.6安装方法基本相同


- 关闭系统大页
```
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled
echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag
```


- 初始化数据库实例并启动数据库

```
/usr/local/percona/scripts/mysql_install_db --basedir=/usr/local/mysql/ --datadir=/data/mysql/mysql3308/data/ --user=mysql 
/usr/local/percona/bin/mysqld_safe --defaults-file=/data/mysql/mysql3308/my.cnf &
```


-  使用ps_tokudb_admin安装tokudb 存储引擎 ，记得实例必须是启动状态的

```
cd /usr/local/percona/bin/
./ps_tokudb_admin --enable  -S  /tmp/mysql3308.sock -p'123456'

Checking if Percona Server is running with jemalloc enabled...
INFO: Percona Server is running with jemalloc enabled.

Checking transparent huge pages status on the system...
INFO: Transparent huge pages are currently disabled on the system.

Checking if thp-setting=never option is already set in config file...
INFO: Option thp-setting=never is set in the config file.

Checking TokuDB engine plugin status...
INFO: TokuDB engine plugin is not installed.

Installing TokuDB engine...
INFO: Successfully installed TokuDB engine plugin.
注意：如果出现以上提示表示安装成功
```

