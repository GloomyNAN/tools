#!/bin/bash
# Author: GloomyNAN
# Date: 2019-06-04
# description: 生产环境备份每日同步

# set
SSH_HOST="120.132.8.84"
SSH_PORT=2333
SSH_USER="ubuntu"
SSH_KEY="~/.ssh/prod_id_rsa"
RSYNC_REMOTE_PATH="/data/backup"
RSYNC_LOCAL_PATH="/data/backup/prod"
LOG_PATH="/data/logs/sync/crm-sync.log"
st=`date +%Y-%m-%d-%H:%M:%S`
rsync -avp -e "ssh -i $SSH_KEY -p $SSH_PORT" $SSH_USER@$SSH_HOST:$RSYNC_REMOTE_PATH $RSYNC_LOCAL_PATH
echo "$st-prod同步完成" >> $LOG_PATH
