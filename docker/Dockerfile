FROM source/centos7:latest

ENV basedir mysql-8.0
ENV mysql_shell mysql_shell
ENV mysql_router mysql_router
ENV datadir mysql3306

	
RUN if [ ! -d /usr/local/mysql ];then ln -s /application/$basedir   /usr/local/mysql; fi
RUN if [ ! -d /usr/local/mysql_shell ];then ln -s /application/$mysql_shell   /usr/local/mysql_shell; fi
RUN if [ ! -d /usr/local/mysql_router ];then ln -s /application/$mysql_router   /usr/local/mysql_router; fi
RUN if ! id mysql &> /dev/null ;then useradd -r -M -s /sbin/nologin mysql ; fi
RUN if [ ! -d /data/mysql/$datadir ];then mkdir -p /data/mysql/$datadir/{data,logs,tmp} &&  chown -R mysql.mysql /data/mysql/$datadir ;fi

RUN if [ ! -f /etc/profile.d/mysql.sh ];then echo 'export PATH=/usr/local/mysql/bin:/usr/local/mysql_shell/bin:/usr/local/mysql-router/bin:$PATH' >> /etc/profile.d/mysql.sh;fi
RUN if [ ! -f /etc/ld.so.conf.d/mysql.conf ];then echo '/usr/local/mysql/lib' > /etc/ld.so.conf.d/mysql.conf;fi
RUN if [ ! -d /usr/include/mysql ];then ln -s /usr/local/mysql/include/ /usr/include/mysql ;fi
RUN if [ -f /etc/man_db.conf -a `grep  '/usr/local/mysql/man' /etc/man_db.conf|wc  -l` -eq 0 ];then sed -ri '22a \MANDATORY_MANPATH /usr/local/mysql/man'  /etc/man_db.conf ;fi
RUN echo -e '[mysql]\nno-auto-rehash\nprompt="\\u@\\h [\\d]>"' > /etc/my.cnf
RUN echo  "/usr/local/mysql/bin/mysqld --defaults-file=/data/mysql/$datadir/my.cnf  & "> /data/mysql/$datadir/start.sh
RUN echo  "/usr/local/mysql/bin/mysqladmin -S /tmp/mysql3306.sock shutdown "> /data/mysql/$datadir/stop.sh



COPY my.cnf /data/mysql/$datadir 
#COPY sysctl.conf /etc/ 
COPY oneinstack.sh /etc/profile.d/
#ADD key.tar.gz /root/.ssh 
RUN chmod +x  /etc/rc.d/rc.local  \
&& echo "sed  -ri  '/sed/,/insecure/d'  /etc/rc.local" >> /etc/rc.d/rc.local \
&& echo "sed  -ri  '16s/3306/'\`date +%N|cut -c 1-5\`'/g'  /data/mysql/$datadir/my.cnf " >> /etc/rc.d/rc.local \
&& echo "/usr/local/mysql/bin/mysqld --defaults-file=/data/mysql/$datadir/my.cnf  --initialize-insecure && /usr/local/mysql/bin/mysqld_safe --defaults-file=/data/mysql/$datadir/my.cnf  & " >> /etc/rc.d/rc.local

#5.6初始化方式需要替换上面一行
#/usr/local/mysql/scripts/mysql_install_db  --user=mysql  --basedir=/usr/local/mysql/  --datadir=/data/mysql/mysql3306/data 
	
WORKDIR /data/mysql/$datadir
EXPOSE 3306 33060 









