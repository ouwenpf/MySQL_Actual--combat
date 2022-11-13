# File Name: MySQL_Install.sh
# Author: Owen
# mail: 
# update Time: 2022-11-13 Sun 
# package：mysql-x.x.xx-linux-glibc2.12-x86_64
# Discription: mkdir /application  tar
#########################################################################

#!/bin/sh
#
install_file="$1"
install_dir="/application"
base_dir="$install_dir/`echo "$1"|awk -F ".tar" '{print $1}'`"
data_dir="/data/mysql"
ip_str=`ip a|grep -A 3 'mtu 1500'|awk  -F '[ /]+' 'NR==3{print $3}'|awk -F '.' '{print $NF}'`

#server_id=${ip_str: -3}
server_id=${2}${ip_str}


if [ ! -f ./my.cnf ];then
        echo 'file my.cnf not exist'
        exit
fi



if [ $# -ne 2 ];then
    echo "Usage: 请输入mysql版本安装包和指定mysql的端口号
例如：mysql-x.x.xx-linux-glibc2.12-x86_64 3306
输入参数个数不对,参数个数为2个
\$2 必须为数字"
    exit
fi


expr $2 "+" 0 &> /dev/null
    if [ $? -ne 0 ];then
	echo "\$2 is not number"
	exit
    fi




if ! [ $2 -ge 3306 -a $2 -le 65535 ];then
        echo "\$2 请输入范围为3306-65535"
        exit

fi 


if [ ! -d ${install_dir} ];then
	mkdir -p  ${install_dir}

fi


if [ -f ${1} ];then
	tar xf ${1}  -C $install_dir
else
	echo "The installation package does not exist"
	exit
	 
fi  



if [ ! -f ${base_dir}/my.cnf ];then
	\cp  my.cnf  ${base_dir}

fi



#
env(){ 
if [ `ping 8.8.8.8 -c 5 | grep "min/avg/max" -c` = '1' ]; then
	yum install -y wget 
        wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo  
        wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo  
        yum install -y libaio libaio-devel psmisc sysstat sysvinit-tools-2.88-14.dsf.el7.x86_64 numactl-libs man bash-completion man-pages-zh-CN.noarch iptables-services lrzsz tree screen telnet dosunix nmap htop openssl openssh openssl-devel bind-utils iotop nc dstat yum-utils*  psacct
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
if [ ! -d $data_dir/mysql$2 ];then
	mkdir -p $data_dir/mysql$2/{data,logs,etc,scripts,tmp}
	echo  "/usr/local/mysql/bin/mysqld_safe --defaults-file=/data/mysql/mysql$2/etc/my.cnf  & "> $data_dir/mysql$2/scripts/start.sh
    echo  "/usr/local/mysql/bin/mysqladmin -S $data_dir/mysql$2/tmp/mysql$2.sock shutdown "> $data_dir/mysql$2/scripts/stop.sh
	chown -R mysql.mysql $data_dir/mysql$2
fi


if [ ! -f $data_dir/mysql$2/etc/my.cnf ];then

   	cp  ${base_dir}/my.cnf $data_dir/mysql$2/etc &&\
	sed -ri  's/3306/'$2'/g'  $data_dir/mysql$2/etc/my.cnf
	sed  -ri  '16s/'$2'/'${server_id}'/g'  $data_dir/mysql$2/etc/my.cnf	
fi
 

if [ ! -d /usr/local/mysql ];then
   	 ln -s ${base_dir}   /usr/local/mysql
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
if [ -f /etc/man_db.conf -a `grep  '/usr/local/mysql/man'  /etc/man_db.conf|wc  -l` -eq 0 ];then
	sed -ri '22a \MANDATORY_MANPATH                       /usr/local/mysql/man'  /etc/man_db.conf
fi


# 
/usr/local/mysql/scripts/mysql_install_db  --user=mysql  --basedir=/usr/local/mysql/ --datadir=$data_dir/mysql$2/data 
sleep 5
if [ $? -eq 0 ];then
	echo "MySQL initialization succeeded"
else
	echo "MySQL initialization failed"
	exit
fi

# 
/usr/local/mysql/bin/mysqld --defaults-file=$data_dir/mysql$2/etc/my.cnf & &> /dev/null
sleep 5

if /usr/local/mysql/bin/mysql -S $data_dir/mysql$2/tmp/mysql$2.sock  -e 'select @@server_id;' &> /dev/null;then
	echo "MySQL started successfully"
else
	echo "MySQL startup failed"
fi
