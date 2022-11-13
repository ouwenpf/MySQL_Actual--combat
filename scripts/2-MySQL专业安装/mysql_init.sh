#!/bin/bash
#

function_package(){
	if [ `ping 8.8.8.8 -c 5 | grep "min/avg/max" -c` = '1' ]; then
		yum install -y wget 
		wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo  
		wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo  
		yum install -y numactl-libs libaio libaio-devel man bash-completion man-pages-zh-CN.noarch iptables-services lrzsz tree screen telnet dosunix nmap htop openssl openssh openssl-devel bind-utils iotop nc dstat yum-utils*  psacct glibc-common strace
	else
		echo "The network connection failed and the installation was terminated!"
		exit
	fi
}

function_oneinstack(){

cat > /etc/profile.d/oneinstack.sh <<-EOF
	HISTSIZE=10000
	#red
	#PS1="\[\e[37;40m\][\[\e[31;40m\]\u\[\e[31;40m\]@\h \[\e[31;40m\]\W\[\e[0m\]]\\\\$ "
	#green
	#PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[32;40m\]@\h \[\e[32;40m\]\W\[\e[0m\]]\\\\$ "
	HISTTIMEFORMAT="%F %T $(whoami) "
	HISTCONTROL="ignoreboth"
	alias ll='ls -hltr --time-style=long-iso'
	alias lh='l | head'
	alias vi='vim'		
EOF

cat > /etc/my.cnf <<-EOF
	[mysql]
	no-auto-rehash
	prompt="\\u@\\h [\\d]>"
EOF

. /etc/profile.d/oneinstack.sh

}

function_system(){

	echo "*                -       nofile          65535" >>/etc/security/limits.conf
	echo "*                -       nproc          65535" >>/etc/security/limits.conf
	#echo 'DefaultLimitNOFILE=65535' >>/etc/systemd/system.conf
	#echo 'DefaultLimitNPROC=65535' >>/etc/systemd/system.conf
	#echo deadline|noop >/sys/block/sda/queue/scheduler
	sysctl -w net.ipv4.tcp_max_syn_backlog=819200
	sysctl -w net.core.netdev_max_backlog=500000
	sysctl -w net.core.somaxconn=4096
	sysctl -w net.ipv4.tcp_tw_reuse=1
	sysctl -w net.ipv4.tcp_timestamps=1
	sysctl -w net.ipv4.tcp_tw_recycle=0
	sysctl -w vm.swappiness=5
	sysctl -w vm.dirty_background_ratio=5
	sysctl -w vm.dirty_ratio=10
}

function_package
function_oneinstack
#function_system
