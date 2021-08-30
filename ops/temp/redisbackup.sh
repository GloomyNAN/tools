#!/bin/bash
# description:  Redis buckup shell script

cd /data/backup/redis   #之前需要创建一个目录用于保存备份数据。
DB_RETENTION_TIME=15
#Set
redis_file="/var/lib/redis/dump.rdb"

#以下不需要做任何修改。
#buckup
tf=`date +%Y%m%d`

#备份redis
cp $redis_file ./
tar czf ${tf}-redis.tar.gz ./*.rdb
rm -fr ./*.rdb



# 删除备份文件。
# Cleaning
find /data/backup/redis -type f -mtime +`echo $[$DB_RETENTION_TIME-1]` -name "*-redis.tar.gz" -exec rm -f {} \;
