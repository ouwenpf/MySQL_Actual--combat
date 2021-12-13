# docker安装及使用

- 安装配置
```
安装yum源
yum install yum-config-manager   -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
国内也可以使用阿里镜像
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

安装docker
yum install -y yum-utils   device-mapper-persistent-data lvm2
yum install -y docker-ce docker-ce-cli containerd.io

之前安装过的可以先卸载
yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
rm -fr /var/lib/docker 默认的镜像存放点，其它如果改动过请到相应的地方进行删除
       
配置镜像仓库
mkdir /etc/docker/
vim  /etc/docker/daemon.json
{
  "registry-mirrors":["https://registry.docker-cn.com"],
  "data-root":"/data/docker/mirrors"
}

registry-mirrors:镜像仓库，可以有多个，用逗号隔开，如"registry-mirrors":["https://rdtmp7tw.mirror.aliyuncs.com","https://registry.docker-cn.com"]
data-root：镜像的存放地点

systemctl start docker.service
docker load  < source-centos7-20200213.tar
docker tag ff54e48932a6 mysql/centos7:latest
docker network create --subnet=10.0.0.0/16 mysqlnet


```
[镜像地址](https://hub.docker.com/)

- 镜像管理命令 

```
docker  
		images:列出镜像
		build:构建镜像来自dockerfile
		inspect：显示一个或者多个镜像的详细信息
		pull:从镜像仓库拉取镜像
		push:推送一个镜像到仓库
		rmi:移除一个或多个镜像
		prune:移除未使用的镜像,没有被标记或被任何容器引用
		tag:创建一个引用镜像标记的镜像
		save:保存一个或多个重定向到tar归档文件   docker save  镜像名称 > 新镜像名称.tar
		load:加载镜像输入来自tar归档文件   docker load < 镜像名称.tar
```

- 创建容器常用选项

```
docker run 
		-i,--interactive:交互式
		-t,--tty:分配一个伪终端
		-d,--detach:运行容器到后台
		--dns list:设置DNS服务器
		-e,--env list:设置环境变量
		--env-file list:从文件读取环境变量
		-p,--publish list:发布容器端口到主机,-p 8080:80或 -p 8000-9000:8000-9000
		-h,--hostname list:设置容器主机名
		--ip string:指定容器ip,只用于自定义网络
		--network:连接容器到一个网络
		--link list:添加连接到另一个容器
		--mount:挂载宿主机分区到容器
		-v,--volume:挂载宿主机目录到容器
		--restart string:容器退出时重启策略,默认no,[always|on-failure]
		--add-host list:添加其他主机到容器中/ect/hosts
		-m,memory:容器可以使用的最大内存
		--cpus:限制容器可以使用多少个可用cpu资源
	
```
- 管理容器常用选项
```
docker [container]
		ls:列出容器
		inspect:显示一个或多个容器的信息信息
		exec:在运行容器中执行命令
		commit:创建一个新镜像来自容器
		cp:拷贝文件/文件夹到容器
		logs:获取容器的日志
		port:列出指定容器隐射的端口
		stats:显示容器资源使用统计
		top:显示容器运行的进程
		update:更新一个或者多个容器配置
		stop/start/restart:停止/启动/重启容器
		rm:删除容器  docker rm -f  `docker ps -qa`
		docker exec  -it mysql8   /bin/bash
		
```

- 构建镜像
```
docker build -t mysql8-19:v1 -f Dockfile[默认此文件名称] [上下文:dockerfile文件中引用的文件]
如：docker build -t mysql8-19:v1  .

```

- 容器数据挂载
```
1. docker volume create mysql-vol创建容器卷
   docker -itd --mount src=mysql-vol , dst=容器中的文件或目录
注意:
	1.如果容器卷不存在,会自动创建
   
2. docker -itd -v 源文件/目录(宿主机):容器中的文件或目录
注意:
	1.如果源文件/目录不存在,不会自动创建,报相应的错误
	2.如果挂载目标在容器中非空目录,则该目录现有的内容会被隐藏
```

- 搭建lnmp环境
```
为了验证前面所学的知识,以下范例搭使用docker单间lnmp环境

1. 自定义网络环境和逻辑卷
docker  network create lnmp
docker	volume create mysql-vol

2. 创建mysql容器
docker run -itd --name lnmp_mysql --net lnmp -p3306:3306 --mount src=mysql-vol,dst=/var/lib/mysql  -e MYSQL_ROOT_PASSWORD=123456 cd3ed0dfff7e  --character-set-server=utf8

3. 创建php环境容器
docker run  -itd  --net lnmp  -p8080:80 --mount type=bind,src=/data/wwwroot,dst=/var/www/html --name lnmp_web richarvey/nginx-php-fpm

4. 下载wordpress到对应的目录
wget -c  https://cn.wordpress.org/latest-zh_CN.tar.gz
```

