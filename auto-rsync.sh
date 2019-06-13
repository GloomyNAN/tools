#!/bin/bash
# Author: GloomyNAN
# Date: 2019-06-13 11:46:55
# description: Rsync定时同步备份

# configriation
SSH_HOST="127.0.0.1"                    # 服务器IP
SSH_PORT=22                             # SSH端口
SSH_USER="root"                         # SSH用户
SSH_KEY="~/.ssh/id_rsa"                 # 私钥
RSYNC_REMOTE_PATH="/data/backup"        # 远程备份地址
RSYNC_LOCAL_PATH="/data/backup"         # 本地备份地址      
LOG_PATH="/data/logs/auto-rsync.sh.log" # 日志目录
datetime=`date +%Y-%m-%d-%H:%M:%S`
rsync -avp -e "ssh -i $SSH_KEY -p $SSH_PORT" $SSH_USER@$SSH_HOST:$RSYNC_REMOTE_PATH $RSYNC_LOCAL_PATH
echo "$datetime-prod同步完成" >> $LOG_PATH