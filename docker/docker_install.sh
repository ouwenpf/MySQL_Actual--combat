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
	yum install -y yum-utils   device-mapper-persistent-data lvm2 docker-ce docker-ce-cli containerd.io

fi

#
mkdir /etc/docker

cat >/etc/docker/daemon.json <<-EOF
{
  "registry-mirrors":["https://registry.docker-cn.com"],
  "data-root":"/data/docker/mirrors"
}
EOF

systemctl start docker.service


