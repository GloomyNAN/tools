#!/bin/bash
# date:2019-06-13 11:15:46
# author:Gloomy
# description:   Local version of MySQL buckup script

# configriation
## mysql配置
DB_BACKPATH="/data/backup/mysql"    # 数据库备份目录，需要提前建立
DB_HOST="127.0.0.1"                 # MySQL IP
DB_USER="backup"                    # MySQL备份用户。
DB_DATABASES="demo"                 # 需要备份的数据库名，使用空格分隔。
DB_PASSWORD="backup"                # MySQL密码
DB_PROT=3306                        # MySQL端口
DB_CHARSET=utf8mb4                  # 字符集
DATA_DIR="/var/lib/mysql"           # MySQL的数据库目录。
MYSQL_DIR="/usr"                    # MySQL的安装目录。

DB_RETENTION_TIME=30                # 数据保留时间
LOG_PATH=/data/logs/mysqlbackup-local.log  # 脚本日志路径
datetime=`date +%Y%m%d%H%M%S`

cd $DB_BACKPATH 

list=`echo $DB_DATABASES | xargs -n1`
for i in $list
do
        if [ -e $DATA_DIR/$i ];then
                $MYSQL_DIR/bin/mysqldump -u$DB_USER -p$DB_PASSWORD -P$DB_PROT $i --set-gtid-purged=off --default-character-set=$DB_CHARSET > $i.sql
                if [ $? -ne 0 ];then
                              echo "$datetime-$i-备份失败" >> $LOG_PATH
                              continue
                fi
                
                tar czf ${i}-${datetime}-database.tar.gz ./${i}.sql
        fi
done

# tar czf ${datetime}-database.tar.gz ./*.sql
rm -fr ./*.sql

#Cleaning
find /data/backup/mysql -type f -mtime +`echo $[$DB_RETENTION_TIME-1]` -name "*-database.tar.gz" -exec rm -f {} \;