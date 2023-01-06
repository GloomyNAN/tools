SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin

# mysql data stored dir
TODAY=`date +%y%m%d`
STOREDIR=/data/mysqldump
mkdir -p $STOREDIR

# delete overtime mysqldump files
#rm -rf /data/mysqldump$(date +%y%m%d --date='15 days ago')

mysqldump  -h ipaddress -u username -ppassword  database > $STOREDIR/$TODAY.dmp

# 如果mysql为高可用版，必须开启mysqldump账户访问域为“%”并执行如下语句
# mysqldump  -h ipaddress -u username -ppassword  database  --set-gtid-purged=OFF > $STOREDIR/$TODAY.dmp