###Welcome to use MarkDown



io_thread.Master_Log_File=sql_thread.Relay_master_Log_File
io_thread.Read_Master_Log_Pos=sql_thread.Exec_Master_Log_Pos



[安装下载](https://github.com/yoshinorim/mha4mysql-manager/releases)  
[参数参考](http://wubx.net/mha-parameters/)
```
yum install perl-DBD-MySQL perl-Config-Tiny perl-Log-Dispatch  perl-Parallel-ForkManager
node安装：
yum localinstall mha4mysql-node-0.58-0.el7.centos.noarch.rpm  -y
manager安装：
yum localinstall mha4mysql-node-0.58-0.el7.centos.noarch.rpm  -y
yum localinstall mha4mysql-manager-0.58-0.el7.centos.noarch.rpm  -y


--查看 ssh 登陆是否成功 
masterha_check_ssh --global_conf=/etc/masterha/masterha_default.conf --conf=/etc/masterha/app1.conf 

--查看复制是否建立好 
masterha_check_repl --global_conf=/etc/masterha/masterha_default.conf --conf=/etc/masterha/app1.conf

--启动
nohup masterha_manager --global_conf=/etc/masterha/masterha_default.conf --conf=/etc/masterha/app1.conf  > /tmp/mha_manager.log 2>&1  &

nohup masterha_manager --global_conf=/etc/masterha/masterha_default.conf --conf=/etc/masterha/app1.conf  --ignore_fail_on_start > /tmp/mha_manager.log 2>&1  &
当有 slave 节点宕掉的情况是启动不了的，加上--ignore_fail_on_start 即使有节点宕掉也能启 动 mha 
需要在配置文件中设置 ignore_fail=1 

--停止
masterha_stop --global_conf=/etc/masterha/masterha_default.conf --conf=/etc/masterha/app1.conf
```