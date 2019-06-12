#!/bin/bash
# Author: GloomyNAN
# Date: 2019-06-12 18:02:53
# description: scp复制脚本

# configriation
SSH_HOST=127.0.0.1  # 服务器IP
SSH_USER=root       # 服务器用户 
SSH_PROT=22         # 服务器端口

LOG_PATH=/data/logs/scp.log  # 日志路径
REMOTE_FILE=/data/www/branch # 远程目录路径
LOCAL_FILE= /data/www/branch # 本地目录路径
datetime=`date "+%Y-%m-%d %H:%M:%S"`

if [ $1 ]; then  
    if [ $1 != "123"   ]; then  
        echo "$st-参数错误" >> $LOG_PATH
        exit
    fi
    scp -r -P $SSH_PROT $SSH_USER@$SSH_HOST:$REMOTE_FILE $LOCAL_FILE
    echo "$st-复制到远程成功！" >> $LOG_PATH
  else
    scp -r $LOCAL_FILE -P $SSH_PROT $SSH_USER@$SSH_HOST:$REMOTE_FILE
    echo "$st-复制到本地成功！" >> $LOG_PATH
fi

