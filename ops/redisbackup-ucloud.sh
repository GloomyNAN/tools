#!/bin/bash
# author:  Gloomy
# date: 2019-06-13 10:03:16
# description:  Ucloud version of Redis backup script

# ucloud云Redis（主备版）定时备份脚本，请先安装云redis管理工具：
# 参考文档：https://docs.ucloud.cn/database/uredis/guide/migration
# 命令参考：
# wget http://redis-import-tool.ufile.ucloud.com.cn/uredis-redis-port
# mv uredis-redis-port uredis
# chmod +x uredis
# sudo mv uredis /usr/local/bin

# configriation
DB_BACKPATH="/data/backup/redis "           # 保存备份目录，需要提前创建好
DB_HOST="127.0.0.1"                         # redis IP
DB_PASSWORD="passcode"                      # redis密码
DB_PROT=6379                                # redis端口
DB_RETENTION_TIME=15                        # 备份保留时间
LOG_PATH=/data/logs/redisbackup-ucloud.log  # 日志路径
datetime=`date "+%Y-%m-%d %H:%M:%S"`

cd $DB_BACKPATH   #之前需要创建一个目录用于保存备份数据。 

# 备份redis
uredis dump -f $DB_HOST:$DB_PROT -P $DB_PASSWORD -o save.rdb
tar czf ${datetime}-redis.tar.gz ./*.rdb
rm -fr ./*.rdb
echo "$datetime-数据备份成功" >> $LOG_PATH

# Cleaning
find $DB_BACKPATH -type f -mtime +`echo $[$DB_RETENTION_TIME-1]` -name "*-redis.tar.gz" -exec rm -f {} \;