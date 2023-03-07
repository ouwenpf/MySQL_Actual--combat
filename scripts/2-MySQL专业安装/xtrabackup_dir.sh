# File Name: MySQL_Install.sh
# Author: Owen
# mail: 
# update Time: 2022-11-13 Sun 
# package：mysql-x.x.xx-linux-glibc2.12-x86_64
# Discription: mkdir /application  tar
#########################################################################

#!/bin/sh
#


data_dir="/data/mysql"
ip_str=`ip a|grep -A 3 'mtu 1500'|awk  -F '[ /]+' 'NR==3{print $3}'|awk -F '.' '{print $NF}'`

#server_id=${ip_str: -3}
server_id=${1}${ip_str}


mycnf(){
cat > my.cnf <<EOF
[client]
port            = 3306
socket=/tmp/mysql3306.sock

[mysql]
socket=/tmp/mysql3306.sock
no-auto-rehash
prompt="\\u@\\h [\\d]>"
#prompt="(\\u@\\h_\R:\m:\\s)[\\d]>"
#pager="less -i -n -S"
#tee=/opt/mysql/query.log

[mysqld]
####: for global
user                                =mysql                          #	mysql
basedir                             =/usr/local/mysql/              #	/usr/local/mysql/
datadir                             =/data/mysql/mysql3306/data     #	/usr/local/mysql/data
server_id                           =3306                         #	0
port                                =3306                           #	3306
character_set_server                =utf8mb4                           #	latin1
skip_character_set_client_handshake = 1								#    0
explicit_defaults_for_timestamp     =off                            #    off
log_timestamps                      =system
default_time_zone		            ='+8:00'                        #	utc
socket                              =/data/mysql/mysql3306/tmp/mysql3306.sock            #	/tmp/mysql.sock
read_only                           = 0                             #   off
super_read_only                     = 0
skip_name_resolve                   =off                            #   0
auto_increment_increment            =1                              #	1
auto_increment_offset               =1                              #	1
lower_case_table_names              =1                              #	0
secure_file_priv                    =/tmp/                          #	null
open_files_limit                    =65536                          #   1024
max_connections                     =1000                           #   151
max_connect_errors					=100000							#   100
wait_timeout						=300							#   28800
interactive_timeout					=300							#   28800
thread_cache_size                   =64                             #   9(线程缓存)
table_open_cache                    =81920                          #   2000
table_definition_cache              =4096                           #   1400
table_open_cache_instances          =64                             #   16
max_prepared_stmt_count             =1048576                        #

####: authenticate
default_authentication_plugin=mysql_native_password 

####: for binlog
binlog_format                       =row                            #	row
log_bin                             =/data/mysql/mysql3306/logs/mysql-bin/mysql-bin                       #	off
binlog_rows_query_log_events        =on                             #	off
log_slave_updates                   =on                             #	off
expire_logs_days                    =7                              #	0
binlog_cache_size                   =65536                          #	65536(64k)
#binlog_checksum                    =none                           #	CRC32
sync_binlog                         =1                              #	1
slave_preserve_commit_order         =ON                             #

####: for error-log
log_error                           =error.log                      #	/usr/local/mysql/data/localhost.localdomain.err

general_log                         =off                            #   off
general_log_file                    =general.log                    #   hostname.log

####: for slow query log
slow_query_log                      =on                             #    off
slow_query_log_file                 =slow.log                       #    hostname.log
long_query_time                     =0.01                      #    10.000000
log_queries_not_using_indexes 		=on								#    off
log_throttle_queries_not_using_indexes = 10							#    0

####: for gtid
#gtid_executed_compression_period    =1000                         #	1000
gtid_mode                           =on                            #	off
enforce_gtid_consistency            =on                            #	off


####: for replication
skip_slave_start                     =1                             #
master_info_repository               =table                         #	file
relay_log_info_repository            =table                         #	file
relay_log                             =/data/mysql/mysql3306/logs/relay-bin/relay-bin
relay_log_recovery					 =1								#   0
relay_log_purge						 =1								#   0
sync_relay_log						 =1								#   10000
sync_relay_log_info					 =1								#   10000
sync_master_info					 =1								#	10000
slave_parallel_type                  =logical_clock                 #    database | LOGICAL_CLOCK
slave_parallel_workers               =4                             #    0
#rpl_semi_sync_master_enabled        =1                             #    0
#rpl_semi_sync_slave_enabled         =1                             #    0
#rpl_semi_sync_master_timeout        =1000                          #    1000(1 second)
#plugin_load_add                     =semisync_master.so            #
#plugin_load_add                     =semisync_slave.so             #
binlog_group_commit_sync_delay       =100                           #    500(0.05%秒)、默认值0
binlog_group_commit_sync_no_delay_count = 20                        #    0
#binlog_order_commits				 =off							#	 0
slave_net_timeout					 =15							#	 60

####: for write_set
binlog_transaction_dependency_tracking         =writeset					#  writeset_session
transaction_write_set_extraction               =XXHASH64					#  XXHASH64
slave_preserve_commit_order					   =0							#  1

####: for innodb
innodb_data_file_path                           =ibdata1:12M:autoextend    #	ibdata1:12M:autoextend
innodb_temp_data_file_path                      =ibtmp1:12M:autoextend      #	ibtmp1:12M:autoextend
innodb_buffer_pool_filename                     =ib_buffer_pool             #	ib_buffer_pool
innodb_log_group_home_dir                       =./                         #	./
innodb_log_files_in_group                       =4                          #	2
innodb_log_file_size                            =48M                       #	50331648(48M)
innodb_file_per_table                           =on                         #	on
innodb_online_alter_log_max_size                =128M                       #   134217728(128M)
innodb_open_files                               =65535                      #   2000
innodb_page_size                                =16k                        #	16384(16k)
innodb_thread_concurrency                       =0                          #	0
innodb_read_io_threads                          =4                          #	4
innodb_write_io_threads                         =4                          #	4
innodb_purge_threads                            =4                          #	4(垃圾回收)
innodb_page_cleaners                            =4                          #   4(刷新lru脏页)
innodb_print_all_deadlocks                      =on                         #	off
innodb_deadlock_detect                          =on                         #	on
innodb_rollback_on_timeout						=on                         #	on
innodb_lock_wait_timeout                        =5                         #	50
innodb_spin_wait_delay                          =128                        #	6
innodb_autoinc_lock_mode                        =2                          #	1
innodb_io_capacity                              =200                        #   200
innodb_io_capacity_max                          =2000                       #   2000
#--------Persistent Optimizer Statistics
innodb_stats_auto_recalc                        =on                         #   on
innodb_stats_persistent                         =on                         #	on
innodb_stats_persistent_sample_pages            =20                         #	20

innodb_change_buffer_max_size                   =25                         #	25
innodb_flush_neighbors                          =1                          #	1
#innodb_flush_method                             =                          #
innodb_doublewrite                              =on                         #	on
innodb_log_buffer_size                          =1024M                       #	16777216(16M)
innodb_flush_log_at_timeout                     =1                          #	1
innodb_flush_log_at_trx_commit                  =1                          #	1
innodb_buffer_pool_size                         =1024M                  		#	134217728(128M)
innodb_buffer_pool_instances                    =4
#--------innodb scan resistant
innodb_old_blocks_pct                           =37                         #    37
innodb_old_blocks_time                          =1000                       #    1000
#--------innodb read ahead
innodb_read_ahead_threshold                     =56                         #    56 (0..64)
innodb_random_read_ahead                        =OFF                        #    OFF
#--------innodb buffer pool state
innodb_buffer_pool_dump_pct                     =25                         #    25
innodb_buffer_pool_dump_at_shutdown             =ON                         #    ON
innodb_buffer_pool_load_at_startup              =ON                         #    ON
innodb_flush_method								=O_DIRECT

EOF

}

mycnf

if [ ! -f ./my.cnf ];then
        echo 'file my.cnf not exist'
        exit
fi



if [ $# -ne 1 ];then
    echo "Usage: 请输入指定mysql的端口号
例如：3306
输入参数个数不对,参数个数为1个
\$1 必须为数字"
    exit
fi


expr $1 "+" 0 &> /dev/null
    if [ $? -ne 0 ];then
	echo "\$1 is not number"
	exit
    fi




if ! [ $1 -ge 3306 -a $1 -le 65535 ];then
        echo "\$1 请输入范围为3306-65535"
        exit

fi 


if ! id mysql &> /dev/null ;then
	useradd -r -M -s /sbin/nologin mysql
fi

# 
if [ ! -d $data_dir/mysql$1 ];then
	mkdir -p $data_dir/mysql$1/{data,logs/{mysql-bin,relay-bin},etc,scripts,tmp}
	echo  "/usr/local/mysql/bin/mysqld_safe --defaults-file=/data/mysql/mysql$1/etc/my.cnf  & "> $data_dir/mysql$1/scripts/start.sh
    echo  "/usr/local/mysql/bin/mysqladmin -S $data_dir/mysql$1/tmp/mysql$1.sock shutdown "> $data_dir/mysql$1/scripts/stop.sh
	chown -R mysql.mysql $data_dir/mysql$1
fi


if [ ! -f $data_dir/mysql$1/etc/my.cnf ];then

   	cp  my.cnf $data_dir/mysql$1/etc &&\
	sed -ri  's/3306/'$1'/g'  $data_dir/mysql$1/etc/my.cnf
	sed  -ri  '/server_id/s/'$1'/'${server_id}'/g'  $data_dir/mysql$1/etc/my.cnf	
	rm  -f  my.cnf 	
fi
 





