#!/bin/bash
#

[ $# -eq 0 ] && echo 'Please enter the extracted file' && exit 
stop_mysql(){
	if [ `ps axu|grep  mysql3306|grep -v grep|wc -l` -eq 1 ];then
		mysqladmin -S  /tmp/mysql3306.sock  shutdown
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
	rm  -rf  /data/mysql/mysql3306/data/*  &&  rm  -f  /data/mysql/mysql3306/logs/*
	mv /data/download/backup/data/* /data/mysql/mysql3306/data/ && chown -R mysql.mysql /data/mysql/mysql3306/data/*
	\cp -a /application/mysql-5.6.45/data_init/mysql/user.*  /data/mysql/mysql3306/data/mysql
	
}

start_mysql(){
	mysqld  --defaults-file=/data/mysql/mysql3306/my.cnf  &
	sleep 60
	netstat -lntup|grep 3306
	mysql -S  /tmp/mysql3306.sock  -e 'show databases;'

}

stop_mysql
tar_bao $1 
mv_file
start_mysql


