#!/bin/bash
# date:2019-05-15 14:43:21
# author:Gloomy
# description:  My VPS Initialized

# 修改系统时区
sudo cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 系统更新
sudo apt-get update
sudo apt-get upgrade -y

## 基础设置
apt-get install -y tree htop nginx unzip mysql mysql-client-5.7

## 目录设置
mkdir -p /data/{www,shell,logs/{admin,api,wechat,www},backup/{redis,mysql}}
chown -R www-data:www-data /data/*

# PHP
apt-get install python-software-properties
add-apt-repository ppa:ondrej/php
apt update

## 7.1系列
apt-get install php7.1-fpm php7.1-mcrypt php7.1-gmp php7.1-mysql php-redis php7.1-mbstring  php7.1-simplexml php7.1-gd php7.1-zip php7.1-bcmath php7.1-curl php7.1-sqlite3 -y
 
## 7.2系列
apt-get install php7.2-fpm php7.2-gmp php7.2-mysql php-redis php7.2-mbstring php7.2-xml php7.2-gd php7.2-zip php7.2-curl -y 

## 7.0系列
sudo apt-get install -y php7.0-fpm libapache2-mod-php7.0 php7.0-cli php7.0-mbstring php7.0-sqlite3 php7.0-opcache php7.0-json php7.0-mysql php7.0-pgsql php7.0-ldap php7.0-gd php7.0-xml php7.0-zip -y 
    
# 包管理器

## nodejs
### 更新ubuntu软件源
sudo apt-get update
sudo apt-get install -y python-software-properties software-properties-common
sudo add-apt-repository -y ppa:chris-lea/node.js 
sudo apt-get update

### 安装nodejs
sudo apt-get y install nodejs nodejs-legacy npm

### 更新npm的包镜像源，方便快速下载
sudo npm config set registry https://registry.npm.taobao.org
sudo npm config list

### 全局安装n管理器(用于管理nodejs版本)
sudo npm install n pm2 -g

### 安装最新的nodejs（stable版本）
sudo n 8.11.4

## composer
# wget https://getcomposer.org/composer.phar
# mv composer.phar composer
# chmod +x composer
# sudo mv composer /usr/local/bin
apt-get install -y composer
composer config -g repo.packagist composer https://packagist.phpcomposer.com

# mysql设置
## 修改sql_mode，兼容order、group by
sudo cat /etc/mysql/mysql.conf.d/myopt.cnf << EOF 
[mysqld]
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
EOF
sudo service mysql restart

# apt-get install -y redis-server redis-tools mysql-client-core-5.7
# apt-get install -y  mysql-server mysql-client-core-5.7 mongodb openjdk-8-jre 


# logsys
# logrotate -vf /etc/logrotate.d/nginx_vhosts 
# logrotate -d /etc/logrotate.d/nginx_vhosts 
sudo cat > /etc/logrotate.d/nginx_vhosts  << EOF 
/data/logs/*/*.log {
        su www-data www-data
        daily
        missingok
        rotate 10000000
        compress
        delaycompress
        notifempty
        create 0640 www-data www-data
        dateext
        sharedscripts
        postrotate
        [ ! -f /var/run/nginx.pid ] || kill -USR1 `cat /var/run/nginx.pid`
        endscript  
}
EOF