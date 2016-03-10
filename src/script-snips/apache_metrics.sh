#!/bin/sh

HOST="$1"

##################
# Apache status
#################

ss_log="/tmp/ss.log"
wget http://localhost/server-status?auto -T 10 -q -O $ss_log

grep BusyWorker $ss_log | awk -v host_name="$HOST" '{print "cust." host_name ".ctf.apache.busy_workers " $2}' 
grep IdleWorker $ss_log | awk -v host_name="$HOST" '{print "cust." host_name ".ctf.apache.idle_workers " $2}' 
grep BytesPerSec $ss_log | awk -v host_name="$HOST" '{print "cust." host_name ".ctf.apache.bytes_per_sec " $2}' 
grep BytesPerReq $ss_log | awk -v host_name="$HOST" '{print "cust." host_name ".ctf.apache.bytes_per_req " $2}' 
grep ReqPerSec $ss_log | awk -v host_name="$HOST" '{print "cust." host_name ".ctf.apache.req_per_sec " $2}' 
