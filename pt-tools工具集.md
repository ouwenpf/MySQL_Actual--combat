# pt-tools工具集使用
[相关说明](https://blog.51cto.com/arthur376/1893321)

```
【DSN】

指定时注意大小写敏感，“=”左右不能有空格，多个值之间用逗号分隔

1. A               charset

2. D               database

3. F                mysql_read_default_file

4. h                host

5. p                password

6. P                port

7. S                mysql_socket

8. t                 table

9.u                  user

```
- pt-mysql-summary  

```
作用:连接mysql后查询出status和配置信息保存到临时目录中，然后用awk和其他的脚本工具进行格式化
pt-mysql-summary  --user=cluster --host=10.0.8.11 --password=123456
注意:只能使用长参数


```


- pt-online-schema-change