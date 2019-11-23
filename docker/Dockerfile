FROM mysql/centos7:latest

ENV basedir mysql-8.0.18
ENV datadir mysql3306


RUN yum install -y wget  && \
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo && \
    yum install -y numactl-libs libaio man bash-completion iptables-services lrzsz tree screen telnet \
    dos2unix nmap htop openssl openssh openssl-devel bind-utils nc dstat yum-utils*  psacct
	
RUN if [ ! -d /usr/local/mysql ];then ln -s /application/mysql-8.0.18    /usr/local/mysql; fi
RUN if ! id mysql &> /dev/null ;then useradd -r -M -s /sbin/nologin mysql ; fi
RUN if [ ! -d /data/mysql/$datadir ];then mkdir -p /data/mysql/$datadir/{data,logs,tmp} &&  chown -R mysql.mysql /data/mysql/$datadir ;fi

RUN if [ ! -f /etc/profile.d/mysql.sh ];then echo 'export PATH=/usr/local/mysql/bin:$PATH' >> /etc/profile.d/mysql.sh;fi
RUN if [ ! -f /etc/ld.so.conf.d/mysql.conf ];then echo '/usr/local/mysql/lib' > /etc/ld.so.conf.d/mysql.conf;fi
RUN if [ ! -d /usr/include/mysql ];then ln -s /usr/local/mysql/include/ /usr/include/mysql ;fi
RUN if [ -f /etc/man_db.conf -a `grep  '/usr/local/mysql/man' /etc/man_db.conf|wc  -l` -eq 0 ];then sed -ri '22a \MANDATORY_MANPATH /usr/local/mysql/man'  /etc/man_db.conf ;fi
RUN echo -e '[mysql]\nno-auto-rehash\nprompt="\\u@\\h [\\d]>"' > /etc/my.cnf
COPY my.cnf /data/mysql/$datadir 
ADD key.tar.gz /root/.ssh
RUN chmod +x  /etc/rc.d/rc.local  &&  \
    echo "sed  -ri  '16s/3306/'\`date +%N|cut -c 1-5\`'/g'  /data/mysql/$datadir/my.cnf " >> /etc/rc.d/rc.local && \
	echo "/usr/local/mysql/bin/mysqld --defaults-file=/data/mysql/$datadir/my.cnf  --initialize-insecure " >> /etc/rc.d/rc.local && \
	echo "/usr/local/mysql/bin/mysqld --defaults-file=/data/mysql/$datadir/my.cnf  &" >> /etc/rc.d/rc.local
WORKDIR /data/mysql/$datadir
EXPOSE 3306 33060 
