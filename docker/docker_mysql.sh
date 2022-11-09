#!/bin/bash
#


if [ $# -lt 3 ];then
    echo "Usage: 请输入mysql版本号，docker中的端口，容器名称，IP主机名
例如：mysq57，11,11
输入参数个数不对
\$2 \$3必须为数字"
    exit
fi


expr $2 "+" 0 &> /dev/null
    if [ $? -ne 0 ];then
	echo "\$2 is not number"
	exit
    fi


expr $3 "+" 0 &> /dev/null
    if [ $? -ne 0 ];then
        echo "\$3 is not number"
        exit
    fi
 

if ! [ $2 -ge 10 -a $2 -le 99 ];then
        echo "\$2 请输入范围为10-99"
        exit

fi    


if ! [ $3 -ge 10 -a $3 -le 99 ];then
        echo "\$3 请输入范围为10-99"
        exit

fi




mysql56(){
	
	
	echo "docker run -d -v /data/tools:/tools  -v /application:/application -v  /etc/resolv.conf:/etc/resolv.conf -p556$1:22 --net mysqlnet --ip 192.168.6.$1 --cap-add=SYS_PTRACE --cap-add=NET_ADMIN  --privileged=true --name mysq56-$2 -h note56-$2 mysql56:v51  /usr/sbin/init"

}


mysql57(){

	echo "docker run -d -v /data/tools:/tools  -v /application:/application -v  /etc/resolv.conf:/etc/resolv.conf -p557$1:22 --net mysqlnet --ip 192.168.7.$1 --cap-add=SYS_PTRACE --cap-add=NET_ADMIN  --privileged=true --name mysq57-$2 -h note57-$2 mysql57:v39  /usr/sbin/init"

}
mysql80(){

	echo "docker run -d -v /data/tools:/tools  -v /application:/application -v  /etc/resolv.conf:/etc/resolv.conf -p558$1:22 --net mysqlnet --ip 192.168.8.$1 --cap-add=SYS_PTRACE --cap-add=NET_ADMIN  --privileged=true --name mysq80-$2 -h note80-$2 mysql80:v30  /usr/sbin/init"

}

usage(){
	
	 echo "Usage: 请输入mysql版本号，docker中的端口，容器名称，IP主机名
例如：mysq57，11,11
输入参数个数不对
\$1必须为{mysql56|mysql57|mysql80}
\$2 \$3必须为数字"
	 


}

case $1 in
mysql56 )
        mysql56 $2 $3
        ;;
mysql57)
        mysql57 $2 $3
        ;;

mysql80)
        mysql80 $2 $3
        ;;
* )     
		usage
        exit 1
        ;;
esac
