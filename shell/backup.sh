#!/bin/bash
# description:  MySQL buckup shell script
# author:       sunkai
# web site:     http://www.1987.name/505.html
# last update:  2012-12-03

cd /data/backup   #之前需要创建一个目录用于保存备份数据。
#Set
st=$(date +%s)
user="root"                              #mysql数据库root用户。
password=""                      #root用户密码。
database=""                         #需要备份的数据库名，使用空格分隔。
mail=""                     #备份结果邮件通知，填写需要通知到的邮件地址。
data_dir="/var/lib/mysql"      #mysql的数据库目录。
mysql_dir="/usr"   #mysql的安装目录。

#以下不需要做任何修改。
#buckup
list=`echo $database | xargs -n1`
tf=`date +%Y%m%d`
for i in $list
do
        if [ -e $data_dir/$i ];
        then
                $mysql_dir/bin/mysqldump -u$user -p$password $i > $i.sql
                if [ $? -ne 0 ];
                then
                        echo "$i" >> sqldump.log
                fi
        fi
done
tar czf ${tf}-database.tar.gz ./*.sql
rm -fr ./*.sql

et=$(date +%s)
difference=$(( et - st ))


#Mail
if [ -e sqldump.log ];
then
        error=`cat sqldump.log | xargs | tr ' ' '/'`
        echo -ne "
        [艺起来数据库] 备份报告
        ------------------------------------------------------
        备份有误！
        错误的库：$error
        备份用时：$difference秒
        文件大小：$(du -sh ${tf}-database.tar.gz | awk '{print $1}')
        备份说明：${tf}-database.tar.gz文件有效期为7天，将在$(date -d "+7 day" +"%Y-%m-%d")删除！
        ------------------------------------------------------
        $(date +"%y/%m/%d  %H:%M:%S")
        " > mail.txt
        mail -s "yqldb Data Buckup Report" $mail < mail.txt
        rm -f sqldump.log; rm -f mail.txt
else 
        echo -ne "
        [火凤凰数据库] 备份报告
        -----------------------------------------------------
        备份完成！
        备份用时：$difference秒
        文件大小：$(du -sh ${tf}-database.tar.gz | awk '{print $1}')
        备份说明：${tf}-database.tar.gz文件有效期为3天，将在$(date -d "+3 day" +"%Y-%m-%d")删除！
        -----------------------------------------------------
        $(date +"%y/%m/%d  %H:%M:%S")
        "  >  mail.txt
        mail -s "yqldb Data Buckup Report" $mail < mail.txt
        rm -f sqldump.log; rm -f mail.txt
fi

#删除7天以上的备份文件。
#Cleaning
find /data/backup/ -type f -mtime +6 -name "*-database.tar.gz" -exec rm -f {} \;


