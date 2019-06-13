#!/bin/bash
# date:2019-06-13 11:22:38
# author:Gloomy
# description:   Lan version of MySQL buckup script

# configriation
DB_BACKPATH="/data/backup/mysql"    # 数据库备份目录，需要提前建立
DB_HOST="127.0.0.1"                 # MySQL IP
DB_USER="backup"                    # MySQL备份用户。
DB_DATABASES="demo"                 # 需要备份的数据库名，使用空格分隔。
DB_PASSWORD="backup"                # MySQL密码
DB_PROT=3306                       # MySQL端口

DB_RETENTION_TIME=30                # 数据保留时间
LOG_PATH=/data/logs/mysqlbackup-local.log  # 脚本日志路径
datetime=`date +%Y%m%d%H%M%S`

cd $DB_BACKPATH   #之前需要创建一个目录用于保存备份数据。

list=`echo $DB_DATABASES | xargs -n1`
for i in $list
do
    mysqldump -h $DB_HOST -u$DB_USER -p$DB_PASSWORD -P$DB_PROT $i --set-gtid-purged=off > $i.sql 
    echo "$datetime-$i-数据备份成功" >> $LOG_PATH
    if [ $? -ne 0 ];then 
        echo "$datetime-$i" >> $LOG_PATH
    fi
done
tar czf ${datetime}-database.tar.gz ./*.sql
rm -fr ./*.sql

# Cleaning
find $DB_BACKPATH -type f -mtime +`echo $[$DB_RETENTION_TIME-1]` -name "*-database.tar.gz" -exec rm -f {} \;