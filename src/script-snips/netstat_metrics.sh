#!/bin/sh

HOST="$1"

netstat1=`netstat -anp | grep 5432 | grep ffff | grep -c ESTABLISHED`
echo "cust.$HOST.netstat.dbconn.estab $netstat1"

