# 目录

- MySQL DBA开篇
- MySQL专业环境安装
	- [MySQL下载](2-MySQL专业安装.md#MySQL下载)
	- [安装前准备](2-MySQL专业安装.md#安装前准备)
	- [MySQL一键安装](2-MySQL专业安装.md#MySQL一键安装)
	- [专业的启动方式](2-MySQL专业安装.md#专业的启动方式)
		- [客户端本地socke连接](2-MySQL专业安装.md#客户端本地socke连接)
		- [账户安全加固](2-MySQL专业安装.md#账户安全加固)
	- [初始化故障排查](2-MySQL专业安装.md#初始化故障排查)
- 多实例部署
	- [为什么要使用多实例](3-多实例安装部署.md#为什么要使用多实例)
		- [资源对其](3-多实例安装部署.md#资源对其)
	- [MySQL多实例启动和关闭的方法](3-多实例安装部署.md#MySQL多实例启动和关闭的方法)
		- [MySQL默认加载配置文件顺序](3-多实例安装部署.md#MySQL默认加载配置文件顺序)
		- [strace分析mysqld启动过程](3-多实例安装部署.md#strace分析mysqld启动过程)
		- [多实例配置文件所注意的事项](3-多实例安装部署.md#多实例配置文件所注意的事项)
	- [篇幅总结](3-多实例安装部署.md#篇幅总结)
- 账户管理
	- [查询MySQL内的账户](4-账户管理.md#查询MySQL内的账户)
		- [5.7升级到8.0之后原来的程序连接数据库报错的解决办法](4-账户管理.md#5.7升级到8.0之后原来的程序连接数据库报错的解决办法)
		- [MySQL账号的组成](4-账户管理.md#MySQL账号的组成)
	- [MySQL账号的组成](4-账户管理.md#MySQL账号的组成)
		- [创建用户](4-账户管理.md#创建用户)
		- [删除用户](4-账户管理.md#删除用户)
		- [修改密码](4-账户管理.md#修改密码)
			- [设置密码过期](4-账户管理.md#设置密码过期)
			- [锁定用户](4-账户管理.md#锁定用户)  
			- [忘记密码怎么解决](4-账户管理.md#忘记密码怎么解决) 
			- [黑科技破解密码](4-账户管理.md#黑科技破解密码) 
	- [权限管理](4-账户管理.md#权限管理)
		- [grant授权](4-账户管理.md#grant授权)
		- [revoke回收](4-账户管理.md#revoke回收)
- MySQL客户端介绍
	- [mysql客户端程序](5-MySQL客户端介绍.md#mysql客户端程序)
		- [mysql客户端工具选项](5-MySQL客户端介绍.md#mysql客户端工具选项)
		- [mysql客户端登录方式](5-MySQL客户端介绍.md#mysql客户端登录方式)
		- [mysql安全更新](5-MySQL客户端介绍.md#mysql安全更新)
		- [mysql输入终结及输出](5-MySQL客户端介绍.md#mysql输入终结及输出)
		- [推荐的客户端GUI工具](5-MySQL客户端介绍.md#推荐的客户端GUI工具)
- MySQL数据类型
	- [整形](数据类型.md#整形)
	- [浮点型](数据类型.md#浮点型)
	- [日期类型](数据类型.md#日期类型)
	- [字符类型](数据类型.md#字符类型)
	- [son类型](数据类型.md#json类型)
	- [字段类型规范](数据类型.md#字段类型规范)
- MySQL字符集
	- [什么是字符集](字符集.md#什么是字符集)
	- [不同字符集编码](字符集.md#不同字符集编码)
		- [字符集必会的实例](字符集.md#字符集必会的实例)
	- [字符集多层面](字符集.md#字符集多层面)
	- [实操数据库转码](字符集.md#实操数据库转码)
	- [了解engine](字符集.md#了解engine)
		- [MySQL官方自带的引擎](字符集.md#MySQL官方自带的引擎)
		- [了解业界其它引擎](字符集.md#了解业界其它引擎)
	- [InnoDB和MyISAM区别](字符集.md#InnoDB和MyISAM区别)		
- 复制原理
	- [主从搭建](复制原理1.md#主从搭建)
		