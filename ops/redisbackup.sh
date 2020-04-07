#!/bin/bash
# author:  Gloomy
# date: 2019-06-13 09:57:20
# description:  Redis buckup script

# configriation
redis_file="/var/lib/redis/dump.rdb"    # redis数据路径
BACKUP_PATH="/data/backup/redis"        # 保存备份目录，需要提前创建好
LOG_PATH=/data/logs/redisbackup.log      # 日志路径
DB_RETENTION_TIME=15                    # 备份保留时间
datetime=`date "+%Y-%m-%d %H:%M:%S"`

cd $BACKUP_PATH

# 备份redis
cp $redis_file ./
tar czf ${datetime}-redis.tar.gz ./*.rdb
rm -fr ./*.rdb
echo "$datetime-数据备份成功" >> $LOG_PATH

#Cleaning
find /data/backup/redis -type f -mtime +`echo $[$DB_RETENTION_TIME-1]` -name "*-redis.tar.gz" -exec rm -f {} \;