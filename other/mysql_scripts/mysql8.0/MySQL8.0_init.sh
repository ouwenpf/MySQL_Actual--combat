#!/bin/bash
#

[ $# -eq 0 ] && echo 'Please enter the port to be initialized' && exit 
stop_mysql(){
	if [ `ps axu|grep  mysql$1|grep -v grep|wc -l` -eq 1 ];then
		mysqladmin -S  /tmp/mysql$1.sock  shutdown
		sleep 5
	fi
}


mv_file(){
	rm  -rf  /data/mysql/mysql$1/data/*  &&  rm  -f  /data/mysql/mysql$1/logs/*
	cp -ar /application/mysql-8.0.17/data_init/* /data/mysql/mysql$1/data/ && chown -R mysql.mysql /data/mysql/mysql$1/data/*
	if [ $? -ne 0 ];then
		echo 'Copying file failed'
		exit 
	fi
	
}

start_mysql(){
	mysqld  --defaults-file=/data/mysql/mysql$1/my.cnf  &
	sleep 60
	netstat -lntup|grep $1
	mysql -S  /tmp/mysql$1.sock  -e 'show databases;'

}

stop_mysql $1
mv_file $1
start_mysql $1


