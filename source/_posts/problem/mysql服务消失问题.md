---
title: mysql服务消失问题
date: 2020-04-05 02:42:00
tags: [problem,mysql]
copyright: philxling
categories: problem
---

## mysql服务消失问题

今天想着从数据库复制一篇文章,然后命令行连接报错,我一看服务消失,应该是装多个没改端口造成的,直接卸载重装

#### 1 官网下载

```
https://dev.mysql.com/downloads/file/?id=492456
```

然后本地卸载mysql后会保留data目录,

#### 2 卸载本地mysql,保留data目录

#### 3 将data目录复制到新的data目录中

注意覆盖文件,(应该新旧mysql版本要一致)mysql5.7的数据库文件都是opt类型,mysql8.0是ibd类型

#### 4 重启mysql服务

```
net start mysql
```

或者到服务中启动(运行`service.msc`)

有可能会报错

```
某些服务在未由其他服务或程序使用时将自动停止
```

这是配置文件有问题,或者data目录文件有错,我是data目录下还有Data目录,将里面的数据库文件复制到data层然后删除Data

重启服务解决.而且数据没有丢失.

mysql8.0的data目录在这个文件下

```
C:\ProgramData\MySQL\MySQL Server 8.0\Data
```

安装目录

```
C:\Program Files\MySQL\MySQL Server 8.0
```



![image-20200405030817266](assets/image-20200405030817266.png)

