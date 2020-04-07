#!/bin/bash
# $1 复制到 $2
# User: srako
# Date: 2019/06/10
# Time: 16:40
# 同步新的分支数据库

# configriation
DB_HOST="127.0.0.1"       # MySQL地址
DB_USER="user"            # MySQy用户
DB_PASSWORD="password"    # MySQL密码
DB_PROT=3306              # MySQL端口

if [ ! $1 ]; then  
  echo "缺少复制库名" 
  exit
fi 

if [ ! $2 ]; then  
  echo "缺少接受库名" 
  exit
fi 

mysqldump $1 -h $DB_HOST -u $DB_USER  -P$DB_PROT | mysql $2 -h $DB_HOST -u $DB_USER -P$DB_PROT

echo "$1 已同步至 $2"