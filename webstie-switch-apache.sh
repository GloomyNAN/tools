#!/bin/bash
# Author: GloomyNAN
# Date: 2019-06-12 18:26:07
# description: apache网站自动开关

SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin

# configriation
SWITCH=$1                   # 网站开关 on-开 off-关
VHOSTS="default.conf website.conf"    # 需要定时启动或关闭的配置文件名，使用空格分隔。
VHOSTS_APACHE_PATH=/usr/local/apache/conf/vhost # apache vhost目录
VHOSTS_ORIGIN_PATH=/data/vhosts
LOG_PATH=/data/logs/website-switch-apache.log  # 日志路径

datetime=`date "+%Y-%m-%d %H:%M:%S"`

if [ $SWITCH != "on" -o  $SWITCH != "off" ]; then
    echo "$datetime-参数错误" >> $LOG_PATH
    exit
fi

list=`echo $VHOSTS | xargs -n1`
for i in $list
do
    if [ $SWITCH == "on" ]; then 
        \cp -f $VHOSTS_ORIGIN_PATH/$i $VHOSTS_APACHE_PATH
        echo "$datetime-复制配置文件 $i 到网站配置目录">> $LOG_PATH
    else
        rm -f $VHOSTS_APACHE_PATH/$i
        echo "$datetime-删除配置文件 $i " >> $LOG_PATH
    fi

    if [ $? -ne 0 ];            
    then 
        echo "$datetime-$i" >> $LOG_PATH
    fi
done

sudo service httpd restart