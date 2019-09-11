#!/bin/bash
#

[ $# -eq 0 ] && echo 'Please enter the extracted file' && exit 
stop_mysql(){
	if [ `ps axu|grep  mysql3308|egrep -v 'grep|mysqld_safe'|wc -l` -eq 1 ];then
		/usr/local/mysql/bin/mysqladmin -S  /tmp/mysql3308.sock  shutdown
		sleep 5
	fi
}

tar_bao(){
	rm -fr /data/download/backup/data/* && tar xf "$1"  -C  /data/download/backup/data
	if [ $? -ne 0 ];then
		echo 'Unpacking the file failed'
		exit
	fi
	innobackupex --apply-log  /data/download/backup/data
	if [ $? -ne 0 ];then
		echo 'apply-log failed'
		exit
	fi
}

mv_file(){
	rm  -rf  /data/mysql/mysql3308/data/*  &&  rm  -f  /data/mysql/mysql3308/logs/*
	mv /data/download/backup/data/* /data/mysql/mysql3308/data/ && chown -R mysql.mysql /data/mysql/mysql3308/data/*
	\cp -a /application/percona-Server-5.6.40/data_init/mysql/user.*  /data/mysql/mysql3308/data/mysql
	
}

start_mysql(){
	/usr/local/mysql/bin/mysqld_safe --defaults-file=/data/mysql/mysql3308/my.cnf &
	sleep 60
	if [ `ps axu|grep  mysql3308|egrep -v 'grep|mysqld_safe'|wc -l` -eq 1 ];then
		echo 'start_mysql success'
	else
		 echo 'start_mysql failure'
		 exit 
	fi	
}

install_tokudb(){
	cd  /usr/local/mysql/bin/ && \
	./ps_tokudb_admin --enable  -S  /tmp/mysql3308.sock  
	if [ $? -eq 0 ];then
		mysql -S  /tmp/mysql3308.sock  -e 'show engines;'|grep TokuDB
	else
		echo 'start_tokudb  failure'
		exit
	fi


}

stop_mysql
tar_bao $1 
mv_file
start_mysql
install_tokudb

