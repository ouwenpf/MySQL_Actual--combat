
mysql 
docker run -itd  -v /data/share:/data/share -p3306:3306  -v /data/app:/application -v  /etc/resolv.conf:/etc/resolv.conf  -v /etc/hosts:/etc/hosts -v /sys/fs/cgroup:/sys/fs/cgroup  --net myvpc  --ip 10.10.10.10  --cap-add=SYS_PTRACE --cap-add=NET_ADMIN  --privileged=true --name mysql8   -h mysql8 mysql8_centos7:latest  /usr/sbin/init


redis
docker run -itd  -v /data/share:/data/share -p6379:6379  -v /data/app:/application -v  /etc/resolv.conf:/etc/resolv.conf  -v /etc/hosts:/etc/hosts -v /sys/fs/cgroup:/sys/fs/cgroup  --net myvpc  --ip 10.10.10.10  --cap-add=SYS_PTRACE --cap-add=NET_ADMIN  --privileged=true --name redis   -h redis redis_centos7:latest  /usr/sbin/init







## 创建Dockerfile文件
# 宿主机上拷贝mv  /data/app/mysql-8.0.24-linux-glibc2.12-x86_64    data/app/mysql-8.0.24     ln -s  ./mysql-8.0.24  ./mysql-8
# 其它相关软件亦是如此

#- 构建镜像

#docker build -t mysql8-19:v1 -f Dockfile[默认此文件名称] [上下文:dockerfile文件中引用的文件]
#如：docker build -t mysql8-19:v1  .