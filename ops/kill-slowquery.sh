#!/bin/bash
# description:  kill slow querys

# set
DB_HOST=""
DB_USER=""
DB_PASSWORD=""
DB_PORT=3306
DB_NAME=""
SQL_QUERY_TIME=10
KILL_QUERY_LOG="/data/logs/kill-slowquery.log"
SLOW_QUERY_SQL="SELECT Id,db,Command,State,Time,Info FROM information_schema.PROCESSLIST where Command like '%Query%' AND Time > ${SQL_QUERY_TIME} And db ='${DB_NAME}' order by Time desc;"
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S")
# Kill Query
echo "${CURRENT_TIME}" >> ${KILL_QUERY_LOG}
for id in $(mysql -h${DB_HOST} -u${DB_USER} -p${DB_PASSWORD} -P${DB_PORT} -se "$SLOW_QUERY_SQL" | awk '{print $1;print $0>>"'${KILL_QUERY_LOG}'"}');do
  if [ $id -gt 0 ]
  then 
      mysql -h${DB_HOST} -u${DB_USER} -p${DB_PASSWORD} -P${DB_PORT} -e "kill ${id}"
  fi
done
echo "---------" >> ${KILL_QUERY_LOG}