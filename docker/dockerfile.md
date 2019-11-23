# Dockerfile常用指令使用

- 常用指令
```
FROM:构建的新镜像是基于哪个镜像
RUN:构建镜像时运行的shell命令
CMD:运行容器时候执行的shell命令
	例如:
		CMD ["/bin/bash","-c","mysqld --defaults-file=my.cnf &"]
		CMD /bin/bash -c 'mysqld --defaults-file=my.cnf &'
EXPOSE:声明容器运行的服务端口
	例如:EXPOSE 3306 33060
ENV:设置容器环境变量
	例如:ENV MYSQL_PASSWORD 123456
ADD:拷贝文件或者目录到镜像,如果是解压文件会自动解压
COPY:只是拷贝文件或目录到镜像
ENTRPOINT:运行容器时执行的shell命令
	例如:
		ENTRPOINT ["/bin/bash","-c","mysqld --defaults-file=my.cnf &"]
		ENTRPOINT /bin/bash -c 'mysqld --defaults-file=my.cnf &'
USER:为RUN,CDM,ENTRYPOINT执行命令指定用户
WORKDIR:设置工作目录
HEALTHCHECK:健康检查
	例如:HEALTHCHECK --interval=5m --timeout=3s --retries=3 \
	     CMD curl -f http://localhost || exit 1
	     
	     
```

- 构建镜像范例
```
FROM 
```