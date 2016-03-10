#!/bin/sh

HOST=$1
SCRIPT_LOC="`pwd -P`"
UTIL_LOC="/var/ops/monitor/utils"
DB_NAME=`grep ^DATABASE_NAME /opt/collabnet/teamforge/runtime/conf/runtime-options.conf  | awk -F= '{print $2}'`

db_line_1=`$UTIL_LOC/check_postgres-2.21.0/check_postgres_dbstats --db=$DB_NAME -t 10`
echo $db_line_1 | awk -F[\ :] -v host_name="$HOST" '{print "cust." host_name ".db.stat.commit " $4\
                                    "\ncust." host_name ".db.stat.read " $8\
                                    "\ncust." host_name ".db.stat.ins " $30\
                                    "\ncust." host_name ".db.stat.upd " $32\
                                    "\ncust." host_name ".db.stat.del " $34
                                }'

db_line_2=`$UTIL_LOC/check_postgres-2.21.0/check_postgres_backends --db=$DB_NAME -t 10`
echo $db_line_2 | awk  -v host_name="$HOST" '{print "cust." host_name ".db.conn.now " $5\
                                                  "\ncust." host_name ".db.conn.max " $7
                                             }'


db_line_3=`$UTIL_LOC/check_postgres-2.21.0/check_postgres_locks --db=$DB_NAME -t 10 | awk -F\| '{print $2}'`
echo $db_line_3 | awk -F[\ =\;] -v host_name="$HOST" '{print "cust." host_name ".db.locks.count " $14\
                                 }'
