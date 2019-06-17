#!/bin/bash
# Author: GloomyNAN
# Date: 2019-06-13 11:39:27
# description:  测试服务器MySQL定时同步

# configriation
DB_HOST="127.0.0.1"   # MySQL IP
DB_USER="user"        # MySQL用户
DB_PASSWORD="pass"    # MySQL密码
DB_PROT=3306          # MySQL端口
DB_BACKUP_PATH="/data/backup/backup/mysql/" # 数据库备份目录
DB_TEST_SQL_PATH="/data/shell/sql/test.sql" # 测试sql文件位置，可写一些更改后台所有用户密码，更改配置等测试SQL
DB_DATABASES=(prod test preview)            # 可以恢复的数据库名，使用空格分隔。
DB_NAME=xiaoyinka.sql

LOG_PATH="/data/logs/sync.log"
datetime=`date +%Y%m%d%H%M%S`


if [ ! $1 ]; then  
  echo "$st-缺少参数" >> $LOG_PATH
  exit
fi    

if echo "${DB_DATABASES[@]}" | grep -w $1 &>/dev/null; then
    echo "$datetime-$1-开始同步数据库" >> $LOG_PATH
  else
    echo "$datetime-参数错误,此数据库不可恢复" >> $LOG_PATH
  exit
fi

cd $DB_BACKUP_PATH
dump=`find ./ -name '*.tar.gz' -mtime -1`
tar -xvf $dump
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -P$DB_PROT $1 < $DB_BACKUP_PATH$DB_NAME
echo "$st-$1-数据库同步完成，数据库:$dump" >> $LOG_PATH

## 同步生产环境不运行test.sql
if [ $1 != 'prod' ]; then  
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -P$DB_PROT $1 < $DB_TEST_SQL_PATH
fi    
# Cleaning
rm -rf *.sql