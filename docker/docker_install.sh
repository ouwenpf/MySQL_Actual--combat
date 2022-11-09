#########################################################################
# File Name: docker_Install.sh
# Author: Owen
# mail: 
# Created 
# package：
# Discription: 
#########################################################################

#!/bin/sh
#

#install yum and docker

if [ `ping 8.8.8.8 -c 5 | grep "min/avg/max" -c` = '1' ]; then
	yum install yum-config-manager   -y
	yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
	yum install -y yum-utils  psmisc sysstat  device-mapper-persistent-data lvm2 docker-ce docker-ce-cli containerd.io

fi

#
mkdir /etc/docker

cat >/etc/docker/daemon.json <<-EOF
{
  "registry-mirrors":["https://registry.docker-cn.com"],
  "data-root":"/data/docker/mirrors"
}
EOF

systemctl start docker.service  启动docker

docker load  < zst_centos7-201806.tar  导入镜像
docker tag 7d0b68af5a06 mysql/centos7:latest  
docker network create --subnet=192.168.0.0/16 mysqlnet 设置网络

mkdir -p /data/tools  /application   
mysql各个版本存放/application
mysql-5.6
mysql-5.7
mysql-8.0


ssh-keygen -t rsa  宿主机上生成密钥对

mkdir /data/docker/build/mysql-{5.7,8.0}
分别存放配置文件，Dockerfile文件等其它需要设置的文件

docker build -t mysql8-19:v1 -f Dockfile[默认此文件名称] [上下文:dockerfile文件中引用的文件]
如：docker build -t mysql8:v30  .    构建镜像

启动镜像
docker run -d -v /data/tools:/tools  -v /application:/application -v  /etc/resolv.conf:/etc/resolv.conf -p55811:22 --net mysqlnet --ip 192.168.8.11 --cap-add=SYS_PTRACE --cap-add=NET_ADMIN  --privileged=true --name mysq80-1 -h note80-1 mysql80:v30  /usr/sbin/init
docker run -d -v /data/tools:/tools  -v /application:/application -v  /etc/resolv.conf:/etc/resolv.conf -p55711:22 --net mysqlnet --ip 192.168.7.11 --cap-add=SYS_PTRACE --cap-add=NET_ADMIN  --privileged=true --name mysq57-1 -h note57-1 mysql57:v39  /usr/sbin/init
docker run -d -v /data/tools:/tools  -v /application:/application -v  /etc/resolv.conf:/etc/resolv.conf -p55711:22 --net mysqlnet --ip 192.168.6.11 --cap-add=SYS_PTRACE --cap-add=NET_ADMIN  --privileged=true --name mysq56-1 -h note56-1 mysql56:v51  /usr/sbin/init

进入容器
docker exec -it  mysq80-1  /bin/bash





















