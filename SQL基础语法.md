#SQL基础语法

- 创建数据库
```
CREATE DATABASE dataname CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER DATABASE dataname CHARACTER SET utf8 COLLATE utf8_general_ci;
对于不知道数据库默认字符和校对规则的情况下，建议加上CHARACTER SET utf8 COLLATE utf8_general_ci

```
- 表的操作
```
1.修改表名称
rename table old_table_name  to new_table_name;
也适用数据库之间的表移动

2.修改默认字符集和排序规则
ALTER TABLE table_name  CHARACTER SET utf8 collate utf8_general_ci;
仅修改table_name表的默认字符集合排序集，并不会修改已有记录的字符集和排序集
ALTER TABLE table_name  CONVERT TO CHARACTER SET utf8 collate utf8_general_ci;
会修改table_name的默认字符集和排序集，也会修改表中已有记录的字符集和排序集

3.新增列
ALTER TABLE table_name ADD column_name VARCHAR(50) NOT NULL DEFAULT '北京'  [FIRST|AFTER col_name];
ALTER TABLE table_name ADD (number1 BIGINT,number2 BIGINT);新增多列

4. 删除列
ALTER TABLE table_name drop column_name;删除列不能同时删除多个

5. 修改列
change修改列名称
CHANGE [COLUMN] old_col_name new_col_name column_definition MODIFY [COLUMN] col_name column_definition [FIRST|AFTER col_name]
ALTER TABLE table_name CHANGE  old_col_name new_col_name VARCHAR(50) NOT NULL DEFAULT '北京' COMMENT '地址';
修改列表需要原来列表的属性，否则无法修改可以使用show create table 查询一下表结构

6. 修改列属性
modify修改列属性
ALTER [COLUMN] col_name {SET DEFAULT literal | DROP DEFAULT} [FIRST | AFTER col_name]
ALTER TABLE table_name modify col_name VARCHAR(50) NOT NULL DEFAULT '北京' COMMENT '地址' AFTER age;

alter增加和删除默认值
ALTER [COLUMN] col_name {SET DEFAULT literal | DROP DEFAULT}
ALTER TABLE table_name  ALTER addr1 SET DEFAULT '北京';
ALTER TABLE test ALTER addr1 DROP DEFAULT;
```

