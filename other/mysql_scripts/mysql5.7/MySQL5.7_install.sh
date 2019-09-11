#########################################################################
# File Name: MySQL_Install.sh
# Author: Owen
# mail: 
# Created Time: 2019-11-07 wed 
# package：mysql-5.7.24-linux-glibc2.12-x86_64
# Discription: mkdir /application  tar
#########################################################################

#!/bin/sh
#
base_dir="/application/mysql-5.7.27"
ip_str=`ip a|grep -A 3 'mtu 1500'|awk  -F '[ /]+' 'NR==3{print $3}'|awk -F '.' '{print $NF}'`
#server_id=${ip_str: -3}
server_id=${1}${ip_str}

if [ $# -eq 0 ];then
	 echo "Usage: $0  {3306|3307|...}"
	 exit 
fi

if [ ! -d ${base_dir} ];then
	 echo "First create the data directory, MySQL package storage location"
	 exit
fi

if [ ! -f ${base_dir}/my.cnf ];then
	echo 'file my.cnf not exist'
	exit
fi

#
env(){ 
if [ `ping 8.8.8.8 -c 5 | grep "min/avg/max" -c` = '1' ]; then
	yum install -y wget 
        wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo  
        wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo  
        yum install -y numactl-libs libaio man bash-completion man-pages-zh-CN.noarch iptables-services lrzsz tree screen telnet dosunix nmap htop openssl openssh openssl-devel bind-utils iotop nc dstat yum-utils*  psacct
else
    	echo "The network connection failed and the installation was terminated!"
    	exit
fi
}

# 
if ! id mysql &> /dev/null ;then
	useradd -r -M -s /sbin/nologin mysql
fi

# 
if [ ! -d /data/mysql/mysql$1 ];then
	mkdir -p /data/mysql/mysql$1/{data,logs,tmp}
	chown -R mysql.mysql /data/mysql/mysql$1
fi


if [ ! -f /data/mysql/mysql$1/my.cnf ];then

   	cp  ${base_dir}/my.cnf /data/mysql/mysql$1 &&\
	sed -ri  's/3306/'$1'/g'  /data/mysql/mysql$1/my.cnf
	sed  -ri  '16s/'$1'/'${server_id}'/g'  /data/mysql/mysql$1/my.cnf	
fi
 

if [ ! -d /usr/local/mysql ];then
   	 ln -s ${base_dir}    /usr/local/mysql
fi




#PATH_file
if [ ! -f /etc/profile.d/mysql.sh ];then
	echo 'export PATH=/usr/local/mysql/bin:$PATH' >> /etc/profile.d/mysql.sh
	source /etc/profile.d/mysql.sh
fi

#lib64_file
if [ ! -f /etc/ld.so.conf.d/mysql.conf ];then
	echo '/usr/local/mysql/lib' > /etc/ld.so.conf.d/mysql.conf
fi

#include_file
if [ ! -d /usr/include/mysql ];then
	ln -s /usr/local/mysql/include/ /usr/include/mysql 
fi

#man_file
if [ ! -f /etc/man_db.conf ];then
	sed -ri '22a \MANDATORY_MANPATH                       /usr/local/mysql/man'  /etc/man_db.conf

fi
# 
/usr/local/mysql/bin/mysqld --defaults-file=/data/mysql/mysql$1/my.cnf  --initialize-insecure 
sleep 5
if [ $? -eq 0 ];then
	echo "MySQL initialization succeeded"
else
	echo "MySQL initialization failed"
	exit
fi

# 
/usr/local/mysql/bin/mysqld --defaults-file=/data/mysql/mysql$1/my.cnf & &> /dev/null
sleep 5

if /usr/local/mysql/bin/mysql -S /tmp/mysql3306.sock  -e 'select @@server_id;' &> /dev/null;then
	echo "MySQL started successfully"
else
	echo "MySQL startup failed"
fi
