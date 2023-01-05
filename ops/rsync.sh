#!/bin/bash
# Author: GloomyNAN
# Date: 2019-06-04
# description: RSYNC Script

# set
SSH_HOST=""
SSH_PORT=22
SSH_USER="root"
SSH_KEY="~/.ssh/id_rsa"
RSYNC_REMOTE_PATH="/data/backup"
RSYNC_LOCAL_PATH="/data/backup/"
LOG_PATH="/data/logs/sync/sync.log"
DATETIME=`date +%Y%m%d%H%M%S`
rsync -avp -e "ssh -i $SSH_KEY -p $SSH_PORT" $SSH_USER@$SSH_HOST:$RSYNC_REMOTE_PATH $RSYNC_LOCAL_PATH
echo "$DATETIME-同步完成" >> $LOG_PATH
