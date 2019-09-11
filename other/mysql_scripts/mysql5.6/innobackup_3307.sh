#!/bin/bash
#

[ $# -eq 0 ] && echo 'Please enter the extracted file' && exit 
stop_mysql(){
	if [ `ps axu|grep  mysql3307|grep -v grep|wc -l` -eq 1 ];then
		mysqladmin -S  /tmp/mysql3307.sock -p'123456' shutdown
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
	rm  -rf  /data/mysql/mysql3307/data/*  &&  rm  -f  /data/mysql/mysql3307/logs/*
	mv /data/download/backup/data/* /data/mysql/mysql3307/data/ && chown -R mysql.mysql /data/mysql/mysql3307/data/*
	\cp -a /application/mysql5.6_data/data/mysql/user.*  /data/mysql/mysql3307/data/mysql
	
}

start_mysql(){
	mysqld  --defaults-file=/data/mysql/mysql3307/my.cnf  &
	sleep 60
	netstat -lntup|grep 3307
	mysql -S  /tmp/mysql3307.sock -p'123456' -e 'show databases;'

}

stop_mysql
tar_bao $1 
mv_file
start_mysql


