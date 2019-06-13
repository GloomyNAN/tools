#!/bin/bash
# Author: GloomyNAN
# Date: 2019-06-13 09:51:15
# Description:  Reids Cache Clearer 

#Set
DB_HOST="127.0.0.1"         # Reids IP
DB_DATABASES=0              # 数据库
DB_PORT=6379                # 端口
DB_PASSWORD="Passcode"      # redis密码
LOG_PATH=/data/logs/redisclear.log # 日志路径
datetime=`date "+%Y-%m-%d %H:%M:%S"`

#需要删除的建，使用空格或换行分隔。
DB_KEYS="cache* SESSION*"      

list=`echo $DB_KEYS | xargs -n1`
for i in $list
do
    redis-cli -h $DB_HOST -p $DB_PORT -a $DB_PASSWORD keys '$i'|xargs redis-cli del
    echo "$st-$i删除成功！" >> $LOG_PATH
    if [ $? -ne 0 ];then 
        echo "$i" >> $LOG_PATH.log
    fi
done