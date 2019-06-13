#!/bin/bash
# date:2019-06-13 11:09:58
# author:Gloomy
# description:  SSH tunnel version of MySQL buckup script

# configriation
## SSH隧道
SSH_HOST="127.0.0.1"            # 服务器IP
SSH_PORT=22                     # ssh端口
SSH_USER="root"                 # 用户名
SSH_TUNNEL_PROT=8989            # ssh通道端口
SSH_KEY="~/.ssh/prod_id_rsa"    # 私钥地址

## mysql配置
DB_BACKPATH="/data/backup/mysql"    # 数据库备份目录，需要提前建立
DB_HOST="127.0.0.1"                 # MySQL IP
DB_USER="backup"                    # mysql备份用户。
DB_DATABASES="demo"                 # 需要备份的数据库名，使用空格分隔。
DB_PASSWORD="backup"                # mysql密码
DB_PROT=3306                        # mysql端口
DB_RETENTION_TIME=30                # 数据保留时间

LOG_PATH=/data/logs/mysqlbackup-ssh.log  # 脚本日志路径
datetime=`date +%Y%m%d%H%M%S`

## 打开ssh隧道
a=`lsof -i:$SSH_TUNNEL_PROT | wc -l`
if [ "$a" -eq "0" ];then
    ssh -NCPf -i $SSH_KEY $SSH_USER@$SSH_HOST -p$SSH_PORT  -L $SSH_TUNNEL_PROT:$DB_HOST:$DB_PROT
fi

cd $DB_BACKPATH

# buckup
list=`echo $DB_DATABASES | xargs -n1`
for i in $list
do
    mysqldump -h 127.0.0.1 -u$DB_USER -p$DB_PASSWORD -P$SSH_TUNNEL_PROT $i --set-gtid-purged=off > $i.sql 
     echo "$datetime-$i-数据备份成功" >> $LOG_PATH
    if [ $? -ne 0 ];            
    then 
        echo "$datetime-$i" >> $LOG_PATH
    fi
done
tar czf ${datetime}-database.tar.gz ./*.sql
rm -fr ./*.sql

# Cleaning
find $DB_BACKPATH -type f -mtime +`echo $[$DB_RETENTION_TIME-1]` -name "*-database.tar.gz" -exec rm -f {} \;

# 关闭通道端口
pid=$(netstat -nlp | grep :$SSH_TUNNEL_PROT | awk '{print $7}' | awk -F"/" '{ print $1 }');

#杀掉对应的进程，如果pid不存在，则不执行
if [  -n  "$pid"  ];  then
    kill  -9  $pid;
fi