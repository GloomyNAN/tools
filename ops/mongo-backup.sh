#!/bin/bash
# date: 2023-01-05 21:40:30
# author: GloomyNAN
# description:   MongoDB Buckup Script

# Configriation
DB_BACKPATH="/data/backup/mongo/"
DB_HOST="127.0.0.1:27017"
DB_DATABASES=""
DB_RETENTION_TIME=365
DATETIME=`date +%Y%m%d%H%M%S`

cd $DB_BACKPATH

mongodump -h $DB_HOST -d $DB_DATABASES -o $DATETIME

tar czf ${$DATETIME}-database.tar.gz $DATETIME
rm -fr ./*.sql

# Cleaning
find $DB_BACKPATH -type f -mtime +`echo $[$DB_RETENTION_TIME-1]` -name "*-database.tar.gz" -exec rm -f {} \;