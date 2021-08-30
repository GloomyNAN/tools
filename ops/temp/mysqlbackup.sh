#!/bin/bash
# description:  MySQL buckup shell script

#Set
st=$(date +%s)
DB_BACKPATH="/data/backup/mysql"
DB_HOST="10.23.55.118"
DB_USER="backup"     #mysql数据库root用户。
DB_DATABASES="hejiajiaju website"      #需要备份的数据库名，使用空格分隔。
DB_PASSWORD="backup" #root用户密码。
DB_PROT=33060
DB_RETENTION_TIME=15
# mysqldump -h 10.23.55.118 -ubackup -pbackup -P33060 hejiajiaju --set-gtid-purged=off > hejiajiaju.sql

cd $DB_BACKPATH   #之前需要创建一个目录用于保存备份数据。

#buckup
list=`echo $DB_DATABASES | xargs -n1`
tf=`date +%Y%m%d`
for i in $list
do
    mysqldump -h $DB_HOST -u$DB_USER -p$DB_PASSWORD -P$DB_PROT $i --set-gtid-purged=off > $i.sql 
    if [ $? -ne 0 ];            
    then 
        echo "$i" >> sqldump.log
    fi
done
tar czf ${tf}-database.tar.gz ./*.sql
rm -fr ./*.sql

# 删除备份文件。
# Cleaning
find $DB_BACKPATH -type f -mtime +`echo $[$DB_RETENTION_TIME-1]` -name "*-database.tar.gz" -exec rm -f {} \;
